import SwiftUI

struct OnboardingNavigationView: View {
    let currentStep: OnboardingStep
    let canProceed: Bool
    let onNext: () -> Void
    let onPrevious: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        // Hide navigation on Welcome and HealthKit steps since they auto-advance
        if currentStep == .welcome || currentStep == .healthKit {
            EmptyView()
        } else {
            HStack(spacing: Spacing.md) {
                // Previous button
                if let _ = currentStep.previous {
                    Button(action: onPrevious) {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                            
                            Text("Back")
                                .font(AppTypography.body(.semibold))
                        }
                        .foregroundColor(AppColors.textSecondary)
                        .padding(Spacing.md)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.background)
                        .cornerRadius(CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.medium)
                                .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Next/Complete button
                Button(action: currentStep == .summary ? onComplete : onNext) {
                    HStack(spacing: Spacing.sm) {
                        Text(currentStep == .summary ? "Get Started" : "Next")
                            .font(AppTypography.body(.semibold))
                        
                        if currentStep != .summary {
                            Image(systemName: "chevron.right")
                                .font(.title3)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(Spacing.md)
                    .frame(maxWidth: .infinity)
                    .background(canProceed ? AppColors.primary : AppColors.textSecondary)
                    .cornerRadius(CornerRadius.medium)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!canProceed)
            }
        }
    }
}

#Preview {
    OnboardingNavigationView(
        currentStep: .welcome,
        canProceed: true,
        onNext: {},
        onPrevious: {},
        onComplete: {}
    )
}
