import SwiftUI

struct OnboardingProgressView: View {
    let currentStep: OnboardingStep
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            // Progress bar
            ProgressView(value: progressValue)
                .progressViewStyle(LinearProgressViewStyle(tint: AppColors.primary))
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppColors.borderLight)
                )
            
            // Step indicators
            HStack(spacing: Spacing.sm) {
                ForEach(OnboardingStep.allCases, id: \.self) { step in
                    Circle()
                        .fill(stepColor(for: step))
                        .frame(width: 8, height: 8)
                        .scaleEffect(step == currentStep ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: currentStep)
                }
            }
            
            // Current step title
            Text(currentStep.title)
                .font(AppTypography.caption(.semibold))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.top, Spacing.lg)
        .padding(.bottom, Spacing.md)
        .background(AppColors.cardBackground)
    }
    
    private var progressValue: Double {
        Double(currentStep.rawValue) / Double(OnboardingStep.allCases.count - 1)
    }
    
    private func stepColor(for step: OnboardingStep) -> Color {
        if step.rawValue < currentStep.rawValue {
            return AppColors.primary
        } else if step == currentStep {
            return AppColors.primary
        } else {
            return AppColors.textSecondary.opacity(0.3)
        }
    }
}

#Preview {
    OnboardingProgressView(currentStep: .goals)
}
