//
//  ContentView.swift
//  nutriplanr
//
//  Created by Dave Mathew on 8/31/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    
    var body: some View {
        Group {
            if appStateManager.isOnboardingComplete {
                // Main app content - TODO: Implement main app view
                VStack(spacing: Spacing.lg) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Welcome to NutriPlanr!")
                        .font(AppTypography.headline())
                        .foregroundColor(AppColors.text)
                    
                    Text("Onboarding completed successfully!")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    if let user = appStateManager.user {
                        VStack(spacing: Spacing.sm) {
                            Text("User Profile:")
                                .font(AppTypography.body(.semibold))
                                .foregroundColor(AppColors.text)
                            
                            Text("Height: \(Int(user.height / 12))'\(Int(user.height.truncatingRemainder(dividingBy: 12)))\"")
                                .font(AppTypography.caption())
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text("Weight: \(Int(user.weight)) lbs")
                                .font(AppTypography.caption())
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text("Age: \(user.age) years")
                                .font(AppTypography.caption())
                                .foregroundColor(AppColors.textSecondary)
                            
                            if user.healthKitData != nil {
                                Text("HealthKit: Connected")
                                    .font(AppTypography.caption())
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(Spacing.md)
                        .background(AppColors.background)
                        .cornerRadius(CornerRadius.medium)
                    }
                }
                .padding(Spacing.xl)
            } else {
                // Show onboarding flow
                OnboardingFlowView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppStateManager())
}
