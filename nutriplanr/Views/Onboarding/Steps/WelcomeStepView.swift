import SwiftUI

struct WelcomeStepView: View {
    @Binding var useHealthKit: Bool
    let onSelection: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // App Icon and Title - More compact
            VStack(spacing: Spacing.md) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.forestGreen)
                
                Text("NutriPlanr")
                    .font(AppTypography.headline())
                    .foregroundColor(AppColors.forestGreen)
                    .multilineTextAlignment(.center)
                
                Text("Your personalized nutrition journey starts here")
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // HealthKit Choice - More compact
            VStack(spacing: Spacing.md) {
                Text("How would you like to get started?")
                    .font(AppTypography.body(.semibold))
                    .foregroundColor(AppColors.text)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: Spacing.sm) {
                    // HealthKit Option
                    Button(action: { 
                        useHealthKit = true
                        onSelection()
                    }) {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "heart.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Sync with Apple Health")
                                    .font(AppTypography.body(.semibold))
                                    .foregroundColor(.white)
                                
                                Text("Automatically import your health data")
                                    .font(AppTypography.caption())
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(Spacing.md)
                        .background(AppColors.forestGreen)
                        .cornerRadius(CornerRadius.medium)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Manual Entry Option
                    Button(action: { 
                        useHealthKit = false
                        onSelection()
                    }) {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .foregroundColor(AppColors.text)
                            
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Enter manually")
                                    .font(AppTypography.body(.semibold))
                                    .foregroundColor(AppColors.text)
                                
                                Text("Set up your profile step by step")
                                    .font(AppTypography.caption())
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(Spacing.md)
                        .background(AppColors.cardBackground)
                        .cornerRadius(CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.medium)
                                .stroke(AppColors.forestGreen.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            // Benefits of HealthKit - More compact and conditional
            if useHealthKit {
                VStack(spacing: Spacing.sm) {
                    Text("What we'll import:")
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    VStack(spacing: Spacing.xs) {
                        BenefitRow(icon: "ruler", text: "Height and weight")
                        BenefitRow(icon: "calendar", text: "Age and gender")
                        BenefitRow(icon: "figure.walk", text: "Activity level (estimated)")
                        BenefitRow(icon: "heart", text: "Health trends and patterns")
                    }
                }
                .padding(Spacing.md)
                .background(AppColors.primary.opacity(0.05))
                .cornerRadius(CornerRadius.medium)
            }
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(AppColors.primary)
                .frame(width: 16)
            
            Text(text)
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
        }
    }
}

#Preview {
    WelcomeStepView(useHealthKit: .constant(false), onSelection: {})
}
