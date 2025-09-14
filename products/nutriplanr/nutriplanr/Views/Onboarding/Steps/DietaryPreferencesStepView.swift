import SwiftUI

struct DietaryPreferencesStepView: View {
    @Binding var userProfile: UserProfile
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.md) {
                    Text("Dietary Preferences")
                        .font(AppTypography.headline())
                        .foregroundColor(AppColors.text)
                    
                    Text("Tell us about your dietary restrictions and cuisine preferences")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Dietary Restrictions
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Dietary Restrictions")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: Spacing.sm) {
                        ForEach(DietaryRestriction.allCases, id: \.self) { restriction in
                            DietaryRestrictionToggleView(
                                restriction: restriction,
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
                
                // Cuisine Preferences
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Cuisine Preferences")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: Spacing.sm) {
                        ForEach(CuisineType.allCases, id: \.self) { cuisine in
                            CuisineToggleView(
                                cuisine: cuisine,
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
            }
        }
    }
}

struct DietaryRestrictionToggleView: View {
    let restriction: DietaryRestriction
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: { onToggle(!isSelected) }) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "checkmark.circle")
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : AppColors.primary)
                    .frame(width: 16)
                
                Text(restriction.displayName)
                    .font(AppTypography.caption(.semibold))
                    .foregroundColor(isSelected ? .white : AppColors.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer()
            }
            .frame(height: 32)
            .padding(.horizontal, Spacing.sm)
            .background(isSelected ? AppColors.primary : AppColors.background)
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CuisineToggleView: View {
    let cuisine: CuisineType
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: { onToggle(!isSelected) }) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "heart.circle")
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : AppColors.primary)
                    .frame(width: 16)
                
                Text(cuisine.displayName)
                    .font(AppTypography.caption(.semibold))
                    .foregroundColor(isSelected ? .white : AppColors.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer()
            }
            .frame(height: 32)
            .padding(.horizontal, Spacing.sm)
            .background(isSelected ? AppColors.primary : AppColors.background)
            .cornerRadius(CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DietaryPreferencesStepView(userProfile: .constant(UserProfile()))
}
