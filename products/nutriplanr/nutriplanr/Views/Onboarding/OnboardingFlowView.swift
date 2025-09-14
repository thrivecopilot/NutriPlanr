import SwiftUI

struct OnboardingFlowView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @State private var currentStep: OnboardingStep = .welcome
    @State private var userProfile = UserProfile()
    @State private var useHealthKit: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress indicator
                OnboardingProgressView(currentStep: currentStep)
                    .padding(.bottom, Spacing.lg)
                
                // Step content
                stepContent
                    .padding(.horizontal, Spacing.xl)
                    .padding(.top, Spacing.lg)
                
                Spacer()
                
                // Navigation buttons
                OnboardingNavigationView(
                    currentStep: $currentStep,
                    onNext: nextStep,
                    onPrevious: previousStep,
                    onComplete: completeOnboarding
                )
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xl)
                .background(
                    Rectangle()
                        .fill(AppColors.cardBackground)
                        .shadow(color: AppShadows.small, radius: 8, x: 0, y: -4)
                )
            }
            .background(AppColors.background)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case .welcome:
            WelcomeStepView(useHealthKit: $useHealthKit, onSelection: {
                // Handle selection and advance appropriately
                if useHealthKit {
                    // Go to HealthKit step
                    currentStep = .healthKit
                } else {
                    // Skip HealthKit step and go to Basic Info
                    currentStep = .basicInfo
                }
            })
        case .healthKit:
            HealthKitStepView(userProfile: $userProfile, onSyncComplete: {
                // Auto-advance to Goals after HealthKit sync
                currentStep = .goals
            })
        case .basicInfo:
            BasicInfoStepView(userProfile: $userProfile)
        case .goals:
            GoalsStepView(userProfile: $userProfile)
        case .dietaryPreferences:
            DietaryPreferencesStepView(userProfile: $userProfile)
        case .mealTiming:
            MealTimingStepView(userProfile: $userProfile)
        case .budget:
            BudgetStepView(userProfile: $userProfile)
        case .summary:
            SummaryStepView(userProfile: userProfile)
        }
    }
    
    private func canProceedToNextStep() -> Bool {
        switch currentStep {
        case .welcome:
            return true
        case .healthKit:
            return true // HealthKit is optional
        case .basicInfo:
            return userProfile.hasBasicInfo
        case .goals:
            return userProfile.hasGoals
        case .dietaryPreferences:
            return true // Dietary preferences are optional
        case .mealTiming:
            return true // Meal timing is optional
        case .budget:
            return true // Budget is optional
        case .summary:
            return true
        }
    }
    
    private func nextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if let next = currentStep.next {
                currentStep = next
            }
        }
    }
    
    private func previousStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch currentStep {
            case .welcome:
                // Can't go back from welcome
                break
            case .healthKit:
                // Go back to welcome
                currentStep = .welcome
            case .basicInfo:
                // Go back to welcome
                currentStep = .welcome
            case .goals:
                // Go back to the appropriate previous step based on flow
                if useHealthKit {
                    currentStep = .healthKit
                } else {
                    currentStep = .basicInfo
                }
            case .dietaryPreferences:
                currentStep = .goals
            case .mealTiming:
                currentStep = .dietaryPreferences
            case .budget:
                currentStep = .mealTiming
            case .summary:
                currentStep = .budget
            }
        }
    }
    
    private func completeOnboarding() {
        // Create user from profile
        let user = userProfile.createUser()
        appStateManager.updateUser(user)
        appStateManager.completeOnboarding()
    }
}

// MARK: - Onboarding Steps
enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case healthKit = 1
    case basicInfo = 2
    case goals = 3
    case dietaryPreferences = 4
    case mealTiming = 5
    case budget = 6
    case summary = 7
    
    var title: String {
        switch self {
        case .welcome: return "Welcome"
        case .healthKit: return "Health Data"
        case .basicInfo: return "Basic Info"
        case .goals: return "Goals"
        case .dietaryPreferences: return "Dietary Preferences"
        case .mealTiming: return "Meal Timing"
        case .budget: return "Budget"
        case .summary: return "Summary"
        }
    }
    
    var next: OnboardingStep? {
        OnboardingStep(rawValue: rawValue + 1)
    }
    
    var previous: OnboardingStep? {
        OnboardingStep(rawValue: rawValue - 1)
    }
}

// MARK: - User Profile (Temporary structure for onboarding)
struct UserProfile {
    // Basic Info - Updated to US Imperial defaults
    var height: Double = 72.0 // inches (6'0")
    var weight: Double = 180.0 // pounds
    var age: Int = 30
    var gender: Gender = .other
    var activityLevel: ActivityLevel = .moderate
    
    // Goals
    var primaryGoal: PrimaryGoal = .maintain
    var goalIntensity: GoalIntensity = .moderate
    var targetWeight: Double?
    var healthImprovementGoals: Set<HealthImprovementGoal> = []
    
    // Preferences
    var dietaryRestrictions: Set<DietaryRestriction> = []
    var cuisinePreferences: Set<CuisineType> = []
    var weeklyBudget: Double = 100.0
    var mealTiming: MealTiming = MealTiming()
    
    // HealthKit
    var useHealthKit: Bool = false
    
    // Computed properties for validation
    var hasBasicInfo: Bool {
        height > 0 && weight > 0 && age > 0
    }
    
    var hasGoals: Bool {
        primaryGoal != .maintain || (targetWeight != nil && targetWeight! > 0)
    }
    
    var hasPreferences: Bool {
        !dietaryRestrictions.isEmpty ||
        !cuisinePreferences.isEmpty ||
        weeklyBudget > 0
    }
    
    func createUser() -> User {
        return User(
            height: height,
            weight: weight,
            age: age,
            gender: gender,
            activityLevel: activityLevel,
            primaryGoal: primaryGoal,
            goalIntensity: goalIntensity,
            targetWeight: targetWeight,
            dietaryRestrictions: dietaryRestrictions,
            cuisinePreferences: cuisinePreferences,
            weeklyBudget: weeklyBudget,
            mealTiming: mealTiming,
            healthImprovementGoals: healthImprovementGoals
        )
    }
    
    func calculateMaintenanceCalories() -> Double {
        // Mifflin-St Jeor Equation (using inches and pounds)
        let heightInCm = height * 2.54
        let weightInKg = weight * 0.453592
        
        let bmr: Double
        switch gender {
        case .male:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) + 5
        case .female:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) - 161
        case .other:
            // Use average of male and female calculations
            let maleBMR = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) + 5
            let femaleBMR = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) - 161
            bmr = (maleBMR + femaleBMR) / 2
        }
        
        return bmr * activityLevel.multiplier
    }
    
    func calculateTargetCalories() -> Double {
        let maintenance = calculateMaintenanceCalories()
        switch primaryGoal {
        case .loseWeight:
            let deficit = goalIntensity.calorieDeficit
            return maintenance - deficit
        case .gainWeight:
            let surplus = goalIntensity.calorieSurplus
            return maintenance + surplus
        case .maintain, .improveHealth:
            return maintenance
        }
    }
}

#Preview {
    OnboardingFlowView()
        .environmentObject(AppStateManager())
}
