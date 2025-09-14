import SwiftUI

struct SummaryStepView: View {
    let userProfile: UserProfile
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.md) {
                    Text("Review Your Profile")
                        .font(AppTypography.headline())
                        .foregroundColor(AppColors.text)
                    
                    Text("Take a moment to review your information before we create your personalized meal plan")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Profile summary cards
                VStack(spacing: Spacing.lg) {
                    BasicInfoSummaryCard(userProfile: userProfile)
                    GoalsSummaryCard(userProfile: userProfile)
                    PreferencesSummaryCard(userProfile: userProfile)
                    HealthKitSummaryCard(userProfile: userProfile)
                }
                
                // Final message
                VStack(spacing: Spacing.md) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    
                    Text("You're All Set!")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(.green)
                    
                    Text("Tap 'Get Started' to begin your nutrition journey with personalized meal plans and recommendations.")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(Spacing.lg)
                .background(Color.green.opacity(0.1))
                .cornerRadius(CornerRadius.medium)
            }
        }
    }
}

struct BasicInfoSummaryCard: View {
    let userProfile: UserProfile
    
    var body: some View {
        SummaryCard(
            title: "Basic Information",
            icon: "person.fill"
        ) {
            VStack(spacing: Spacing.sm) {
                SummaryRow(label: "Height", value: "\(Int(userProfile.height)) cm")
                SummaryRow(label: "Weight", value: "\(Int(userProfile.weight)) kg")
                SummaryRow(label: "Age", value: "\(userProfile.age) years")
                SummaryRow(label: "Gender", value: userProfile.gender.displayName)
                SummaryRow(label: "Activity Level", value: userProfile.activityLevel.displayName)
            }
        }
    }
}

struct GoalsSummaryCard: View {
    let userProfile: UserProfile
    
    var body: some View {
        SummaryCard(
            title: "Your Goals",
            icon: "target"
        ) {
            VStack(spacing: Spacing.sm) {
                SummaryRow(label: "Primary Goal", value: userProfile.primaryGoal.displayName)
                SummaryRow(label: "Intensity", value: userProfile.goalIntensity.displayName)
                
                if let targetWeight = userProfile.targetWeight {
                    SummaryRow(label: "Target Weight", value: "\(Int(targetWeight)) kg")
                }
                
                let maintenanceCalories = userProfile.calculateMaintenanceCalories()
                let targetCalories = userProfile.calculateTargetCalories()
                
                SummaryRow(label: "Maintenance Calories", value: "\(Int(maintenanceCalories)) kcal")
                SummaryRow(label: "Target Calories", value: "\(Int(targetCalories)) kcal")
            }
        }
    }
}

struct PreferencesSummaryCard: View {
    let userProfile: UserProfile
    
    var body: some View {
        SummaryCard(
            title: "Preferences",
            icon: "heart.fill"
        ) {
            VStack(spacing: Spacing.sm) {
                if !userProfile.dietaryRestrictions.isEmpty {
                    SummaryRow(
                        label: "Dietary Restrictions",
                        value: userProfile.dietaryRestrictions.map { $0.displayName }.joined(separator: ", ")
                    )
                }
                
                if !userProfile.cuisinePreferences.isEmpty {
                    SummaryRow(
                        label: "Cuisine Preferences",
                        value: userProfile.cuisinePreferences.map { $0.displayName }.joined(separator: ", ")
                    )
                }
                
                SummaryRow(label: "Weekly Budget", value: "$\(Int(userProfile.weeklyBudget))")
                
                let mealCount = [
                    userProfile.mealTiming.includeBreakfast,
                    userProfile.mealTiming.includeLunch,
                    userProfile.mealTiming.includeDinner,
                    userProfile.mealTiming.includeSnacks
                ].filter { $0 }.count
                
                SummaryRow(label: "Meals per Day", value: "\(mealCount)")
            }
        }
    }
}

struct HealthKitSummaryCard: View {
    let userProfile: UserProfile
    
    var body: some View {
        SummaryCard(
            title: "Health Data",
            icon: "heart.fill"
        ) {
            VStack(spacing: Spacing.sm) {
                SummaryRow(
                    label: "HealthKit Sync",
                    value: userProfile.useHealthKit ? "Enabled" : "Disabled"
                )
                
                if userProfile.useHealthKit {
                    SummaryRow(
                        label: "Data Types",
                        value: "Height, Weight, Age, Gender, Activity"
                    )
                }
            }
        }
    }
}

struct SummaryCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: icon)
                    .foregroundColor(AppColors.primary)
                    .font(.title2)
                
                Text(title)
                    .font(AppTypography.body(.semibold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
            }
            
            content
        }
        .padding(Spacing.lg)
        .background(AppColors.background)
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(AppColors.primary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppTypography.caption(.semibold))
                .foregroundColor(AppColors.text)
        }
    }
}

#Preview {
    SummaryStepView(userProfile: UserProfile())
}



