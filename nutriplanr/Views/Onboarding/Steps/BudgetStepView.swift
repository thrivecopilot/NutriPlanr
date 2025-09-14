import SwiftUI

struct BudgetStepView: View {
    @Binding var userProfile: UserProfile
    @State private var budgetString: String = "100"
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.md) {
                    Text("Weekly Budget")
                        .font(AppTypography.headline())
                        .foregroundColor(AppColors.text)
                    
                    Text("Set your weekly food budget to help NutriPlanr recommend appropriate nutrition plans")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Budget Input
                VStack(spacing: Spacing.lg) {
                    HStack {
                        Text("$")
                            .font(AppTypography.display())
                            .foregroundColor(AppColors.primary)
                        
                        TextField("100", text: $budgetString)
                            .font(AppTypography.display())
                            .keyboardType(.decimalPad)
                            .textFieldStyle(PlainTextFieldStyle())
                            .onChange(of: budgetString) { newValue in
                                if let budget = Double(newValue) {
                                    userProfile.weeklyBudget = budget
                                }
                            }
                        
                        Text("per week")
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(Spacing.xl)
                    .background(AppColors.background)
                    .cornerRadius(CornerRadius.large)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.large)
                            .stroke(AppColors.primary.opacity(0.3), lineWidth: 2)
                    )
                    
                    // Budget Guidelines
                    VStack(spacing: Spacing.md) {
                        Text("Budget Guidelines")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                        
                        VStack(spacing: Spacing.sm) {
                            BudgetGuidelineRow(
                                range: "$50-75",
                                description: "Budget-friendly meals with simple ingredients"
                            )
                            
                            BudgetGuidelineRow(
                                range: "$75-100",
                                description: "Balanced meals with quality ingredients"
                            )
                            
                            BudgetGuidelineRow(
                                range: "$100-150",
                                description: "Premium meals with organic and specialty items"
                            )
                            
                            BudgetGuidelineRow(
                                range: "$150+",
                                description: "Gourmet meals with premium ingredients"
                            )
                        }
                    }
                    .padding(Spacing.lg)
                    .background(AppColors.primary.opacity(0.05))
                    .cornerRadius(CornerRadius.medium)
                }
            }
            .padding(.bottom, Spacing.xl)
        }
        .onAppear {
            budgetString = String(Int(userProfile.weeklyBudget))
        }
    }
}

struct BudgetGuidelineRow: View {
    let range: String
    let description: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            Text(range)
                .font(AppTypography.body(.semibold))
                .foregroundColor(AppColors.primary)
                .frame(width: 80, alignment: .leading)
                .fixedSize(horizontal: true, vertical: false)
            
            Text(description)
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

#Preview {
    BudgetStepView(userProfile: .constant(UserProfile()))
}
