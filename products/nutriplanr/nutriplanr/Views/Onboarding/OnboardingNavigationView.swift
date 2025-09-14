import SwiftUI

struct OnboardingNavigationView: View {
    @Binding var currentStep: OnboardingStep
    let onNext: () -> Void
    let onPrevious: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Navigation buttons
            HStack(spacing: Spacing.md) {
                // Previous button (hidden on first steps)
                if shouldShowPreviousButton {
                    Button(action: onPrevious) {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(AppTypography.body(.medium))
                        }
                        .foregroundColor(AppColors.text)
                        .padding(.horizontal, Spacing.lg)
                        .padding(.vertical, Spacing.md)
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.medium)
                                .stroke(AppColors.border, lineWidth: 1)
                        )
                    }
                }
                
                Spacer()
                
                // Next/Complete button
                Button(action: {
                    if currentStep == .summary {
                        onComplete()
                    } else {
                        onNext()
                    }
                }) {
                    HStack(spacing: Spacing.sm) {
                        Text(currentStep == .summary ? "Get Started" : "Next")
                            .font(AppTypography.body(.semibold))
                        
                        if currentStep != .summary {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.md)
                    .background(AppColors.primary)
                    .cornerRadius(CornerRadius.medium)
                }
                .disabled(!canProceed)
                .opacity(canProceed ? 1.0 : 0.6)
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.lg)
        .padding(.bottom, Spacing.xl)
    }
    
    private var shouldShowPreviousButton: Bool {
        switch currentStep {
        case .welcome, .healthKit:
            return false
        default:
            return true
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case .welcome, .healthKit:
            return true
        case .basicInfo:
            return true // Will be validated in the step view
        case .goals:
            return true // Will be validated in the step view
        case .dietaryPreferences:
            return true
        case .mealTiming:
            return true
        case .budget:
            return true
        case .summary:
            return true
        }
    }
}

#Preview {
    OnboardingNavigationView(
        currentStep: .constant(.goals),
        onNext: {},
        onPrevious: {},
        onComplete: {}
    )
}