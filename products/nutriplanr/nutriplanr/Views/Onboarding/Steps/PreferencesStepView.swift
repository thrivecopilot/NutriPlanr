import SwiftUI

struct PreferencesStepView: View {
    @Binding var userProfile: UserProfile
    @State private var weeklyBudgetString: String = "100"
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.md) {
                    Text("Your Preferences")
                        .font(AppTypography.headline())
                        .foregroundColor(AppColors.text)
                    
                    Text("Customize your meal plans to match your lifestyle and preferences")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Dietary Restrictions - 3-column grid for better text fitting
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Dietary Restrictions")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Spacing.sm), count: 3), spacing: Spacing.sm) {
                        ForEach(DietaryRestriction.allCases, id: \.self) { restriction in
                            PreferenceToggleView(
                                title: restriction.displayName,
                                isSelected: userProfile.dietaryRestrictions.contains(restriction),
                                onToggle: { isSelected in
                                    if isSelected {
                                        userProfile.dietaryRestrictions.insert(restriction)
                                    } else {
                                        userProfile.dietaryRestrictions.remove(restriction)
                                    }
                                }
                            )
                        }
                    }
                }
                
                // Cuisine Preferences - 3-column grid for better text fitting
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Cuisine Preferences")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Spacing.sm), count: 3), spacing: Spacing.sm) {
                        ForEach(CuisineType.allCases, id: \.self) { cuisine in
                            PreferenceToggleView(
                                title: cuisine.displayName,
                                isSelected: userProfile.cuisinePreferences.contains(cuisine),
                                onToggle: { isSelected in
                                    if isSelected {
                                        userProfile.cuisinePreferences.insert(cuisine)
                                    } else {
                                        userProfile.cuisinePreferences.remove(cuisine)
                                    }
                                }
                            )
                        }
                    }
                }
                
                // Weekly Budget
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Weekly Grocery Budget")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    HStack {
                        Text("$")
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.textSecondary)
                        
                        TextField("Budget", text: $weeklyBudgetString)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: weeklyBudgetString) { newValue in
                                if let budget = Double(newValue) {
                                    userProfile.weeklyBudget = budget
                                }
                            }
                        
                        Text("per week")
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Text("This helps us suggest cost-effective meal options")
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.textSecondary)
                }
                
                // Meal Timing
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Meal Timing")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    VStack(spacing: Spacing.md) {
                        MealTimingRow(
                            title: "Breakfast",
                            time: $userProfile.mealTiming.breakfastTime,
                            isEnabled: $userProfile.mealTiming.includeBreakfast
                        )
                        
                        MealTimingRow(
                            title: "Lunch",
                            time: $userProfile.mealTiming.lunchTime,
                            isEnabled: $userProfile.mealTiming.includeLunch
                        )
                        
                        MealTimingRow(
                            title: "Dinner",
                            time: $userProfile.mealTiming.dinnerTime,
                            isEnabled: $userProfile.mealTiming.includeDinner
                        )
                        
                        MealTimingRow(
                            title: "Snacks",
                            time: $userProfile.mealTiming.snackTime,
                            isEnabled: $userProfile.mealTiming.includeSnacks
                        )
                    }
                }
                
                // Intermittent Fasting
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Intermittent Fasting")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    VStack(spacing: Spacing.md) {
                        Toggle("Enable Intermittent Fasting", isOn: $userProfile.mealTiming.intermittentFasting)
                        
                        if userProfile.mealTiming.intermittentFasting {
                            VStack(spacing: Spacing.sm) {
                                HStack {
                                    Text("Fasting Start:")
                                    Spacer()
                                    DatePicker("", selection: $userProfile.mealTiming.fastingStartTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }
                                
                                HStack {
                                    Text("Fasting End:")
                                    Spacer()
                                    DatePicker("", selection: $userProfile.mealTiming.fastingEndTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }
                                
                                HStack {
                                    Text("No Food After:")
                                    Spacer()
                                    DatePicker("", selection: $userProfile.mealTiming.noFoodAfter, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }
                            }
                            .font(AppTypography.caption())
                            .foregroundColor(AppColors.textSecondary)
                        }
                    }
                }
                
                // Summary
                if userProfile.hasPreferences {
                    PreferencesSummaryView(userProfile: userProfile)
                }
            }
            .padding(Spacing.lg)
        }
        .onAppear {
            weeklyBudgetString = String(Int(userProfile.weeklyBudget))
        }
    }
}

// MARK: - Helper Views

struct PreferenceToggleView: View {
    let title: String
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: { onToggle(!isSelected) }) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(AppTypography.caption(.semibold))
                    .foregroundColor(isSelected ? AppColors.text : AppColors.textSecondary)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(Spacing.sm)
            .frame(minHeight: 50) // Reduced height for 3-column layout
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

struct MealTimingRow: View {
    let title: String
    @Binding var time: Date
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack {
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
            
            Text(title)
                .font(AppTypography.body())
                .foregroundColor(AppColors.text)
            
            Spacer()
            
            if isEnabled {
                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(CompactDatePickerStyle())
            }
        }
    }
}

struct PreferencesSummaryView: View {
    let userProfile: UserProfile
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            Text("Your Preferences Summary")
                .font(AppTypography.body(.semibold))
                .foregroundColor(AppColors.text)
            
            VStack(spacing: Spacing.sm) {
                if !userProfile.dietaryRestrictions.isEmpty {
                    HStack {
                        Text("Dietary Restrictions:")
                        Spacer()
                        Text(userProfile.dietaryRestrictions.map { $0.displayName }.joined(separator: ", "))
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.primary)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                if !userProfile.cuisinePreferences.isEmpty {
                    HStack {
                        Text("Cuisine Preferences:")
                        Spacer()
                        Text(userProfile.cuisinePreferences.map { $0.displayName }.joined(separator: ", "))
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.primary)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                HStack {
                    Text("Weekly Budget:")
                    Spacer()
                    Text("$\(Int(userProfile.weeklyBudget))")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.primary)
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

#Preview {
    PreferencesStepView(userProfile: .constant(UserProfile()))
}
