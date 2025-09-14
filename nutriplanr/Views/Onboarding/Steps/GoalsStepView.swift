import SwiftUI

struct GoalsStepView: View {
    @Binding var userProfile: UserProfile
    @State private var targetWeightString: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.md) {
                    Text("Your Goals")
                        .font(AppTypography.headline())
                        .foregroundColor(AppColors.text)
                    
                    Text("What would you like to achieve? This helps NutriPlanr create the perfect nutrition plan for you")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Weight Goal Section
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Weight Goal")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    VStack(spacing: Spacing.md) {
                        ForEach([PrimaryGoal.loseWeight, .gainWeight, .maintain], id: \.self) { goal in
                            VStack(spacing: Spacing.sm) {
                                GoalOptionView(
                                    goal: goal,
                                    isSelected: userProfile.primaryGoal == goal,
                                    onSelect: { userProfile.primaryGoal = goal }
                                )
                                
                                // Show target weight and intensity directly under selected goal
                                if userProfile.primaryGoal == goal && goal != .maintain {
                                    VStack(alignment: .leading, spacing: Spacing.md) {
                                        // Target Weight (only show for lose/gain weight)
                                        if goal == .loseWeight || goal == .gainWeight {
                                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                                Text("Target Weight")
                                                    .font(AppTypography.body(.semibold))
                                                    .foregroundColor(AppColors.text)
                                                
                                                HStack {
                                                    TextField("Target weight", text: $targetWeightString)
                                                        .keyboardType(.decimalPad)
                                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                                        .onChange(of: targetWeightString) { newValue in
                                                            if let weight = Double(newValue) {
                                                                userProfile.targetWeight = weight
                                                            }
                                                        }
                                                    
                                                    Text("lbs")
                                                        .font(AppTypography.body())
                                                        .foregroundColor(AppColors.textSecondary)
                                                }
                                            }
                                        }
                                        
                                        // Goal Intensity
                                        VStack(alignment: .leading, spacing: Spacing.md) {
                                            Text("Goal Intensity")
                                                .font(AppTypography.body(.semibold))
                                                .foregroundColor(AppColors.text)
                                            
                                            Picker("Goal Intensity", selection: $userProfile.goalIntensity) {
                                                ForEach(GoalIntensity.allCases, id: \.self) { intensity in
                                                    Text(intensity.displayName).tag(intensity)
                                                }
                                            }
                                            .pickerStyle(SegmentedPickerStyle())
                                            
                                            Text(intensityDescription)
                                                .font(AppTypography.caption())
                                                .foregroundColor(AppColors.textSecondary)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                    .padding(.leading, Spacing.md)
                                    .padding(.top, Spacing.sm)
                                }
                            }
                        }
                    }
                }
                
                // Health Focus Areas Section
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Health Focus Areas")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Spacing.sm), count: 2), spacing: Spacing.sm) {
                        ForEach(HealthImprovementGoal.allCases, id: \.self) { goal in
                            HealthGoalToggleView(
                                goal: goal,
                                isSelected: userProfile.healthImprovementGoals.contains(goal),
                                onToggle: { isSelected in
                                    if isSelected {
                                        userProfile.healthImprovementGoals.insert(goal)
                                    } else {
                                        userProfile.healthImprovementGoals.remove(goal)
                                    }
                                }
                            )
                        }
                    }
                }
                

                
                // Goal Preview
                if userProfile.hasGoals {
                    GoalPreviewView(userProfile: userProfile)
                }
            }
        }
        .onAppear {
            if let targetWeight = userProfile.targetWeight {
                targetWeightString = String(Int(targetWeight))
            }
        }
    }
    
    private var intensityDescription: String {
        switch userProfile.goalIntensity {
        case .slow:
            return "Slow and steady progress, easier to maintain"
        case .moderate:
            return "Balanced approach for sustainable results"
        case .aggressive:
            return "Faster progress, requires more discipline"
        }
    }
}

struct GoalOptionView: View {
    let goal: PrimaryGoal
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: Spacing.md) {
                Image(systemName: goal.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : AppColors.primary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(goal.displayName)
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(isSelected ? .white : AppColors.text)
                    
                    Text(goal.description)
                        .font(AppTypography.caption())
                        .foregroundColor(isSelected ? .white.opacity(0.8) : AppColors.textSecondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            .padding(Spacing.md)
            .background(isSelected ? AppColors.primary : AppColors.background)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(isSelected ? AppColors.primary : AppColors.primary.opacity(0.3), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GoalPreviewView: View {
    let userProfile: UserProfile
    
    private var calorieTarget: Double {
        let maintenance = userProfile.calculateMaintenanceCalories()
        switch userProfile.primaryGoal {
        case .loseWeight:
            let deficit = userProfile.goalIntensity.calorieDeficit
            return maintenance - deficit
        case .gainWeight:
            let surplus = userProfile.goalIntensity.calorieSurplus
            return maintenance + surplus
        case .maintain, .improveHealth:
            return maintenance
        }
    }
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            Text("Your Plan")
                .font(AppTypography.body(.semibold))
                .foregroundColor(AppColors.text)
            
            VStack(spacing: Spacing.sm) {
                HStack {
                    Text("Daily Calories:")
                    Spacer()
                    Text("\(Int(calorieTarget)) Calories")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.primary)
                }
                
                HStack {
                    Text("Goal:")
                    Spacer()
                    Text(userProfile.primaryGoal.displayName)
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.primary)
                }
                
                if let targetWeight = userProfile.targetWeight {
                    HStack {
                        Text("Target Weight:")
                        Spacer()
                        Text("\(Int(targetWeight)) lbs")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
            .font(AppTypography.caption())
            .foregroundColor(AppColors.textSecondary)
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

struct HealthGoalToggleView: View {
    let goal: HealthImprovementGoal
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: { onToggle(!isSelected) }) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: goal.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                    .frame(width: 24, height: 24)
                
                Text(goal.displayName)
                    .font(AppTypography.caption(.semibold))
                    .foregroundColor(isSelected ? AppColors.text : AppColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(Spacing.sm)
            .frame(minHeight: 60)
            .background(isSelected ? AppColors.primary.opacity(0.1) : AppColors.background)
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(isSelected ? AppColors.primary : AppColors.primary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GoalsStepView(userProfile: .constant(UserProfile()))
}
