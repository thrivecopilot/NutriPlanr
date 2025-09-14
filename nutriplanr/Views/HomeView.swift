import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard Tab
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
                .tag(0)
            
            // Nutrition Tab
            NutritionView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Nutrition")
                }
                .tag(1)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(AppColors.forestGreen)
    }
}

struct DashboardView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Welcome Header
                    VStack(spacing: Spacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Welcome back!")
                                    .font(AppTypography.body())
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Text("Ready to fuel your goals?")
                                    .font(AppTypography.headline())
                                    .foregroundColor(AppColors.text)
                            }
                            
                            Spacer()
                            
                            // Profile Avatar
                            Circle()
                                .fill(AppColors.forestGreen.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.title2)
                                        .foregroundColor(AppColors.forestGreen)
                                )
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.md)
                    
                    // Quick Stats Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: Spacing.md) {
                        if let user = appStateManager.user {
                            StatCard(
                                title: "BMI",
                                value: String(format: "%.1f", user.bmi),
                                subtitle: bmiCategory(user.bmi),
                                icon: "figure.stand",
                                color: AppColors.forestGreen
                            )
                            
                            StatCard(
                                title: "Target Calories",
                                value: "\(Int(user.targetCalories))",
                                subtitle: "cal/day",
                                icon: "flame.fill",
                                color: AppColors.lightForestGreen
                            )
                            
                            StatCard(
                                title: "Goal",
                                value: user.primaryGoal.displayName,
                                subtitle: user.goalIntensity.displayName,
                                icon: user.primaryGoal.icon,
                                color: AppColors.forestGreen
                            )
                            
                            StatCard(
                                title: "Budget",
                                value: "$\(Int(user.weeklyBudget))",
                                subtitle: "per week",
                                icon: "dollarsign.circle.fill",
                                color: AppColors.lightForestGreen
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    
                    // Health Goals Section
                    if let user = appStateManager.user, !user.healthImprovementGoals.isEmpty {
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("Your Health Goals")
                                .font(AppTypography.body(.semibold))
                                .foregroundColor(AppColors.text)
                                .padding(.horizontal, Spacing.lg)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Spacing.md) {
                                    ForEach(Array(user.healthImprovementGoals), id: \.self) { goal in
                                        GoalCard(goal: goal)
                                    }
                                }
                                .padding(.horizontal, Spacing.lg)
                            }
                        }
                    }
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Quick Actions")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                            .padding(.horizontal, Spacing.lg)
                        
                        VStack(spacing: Spacing.sm) {
                            QuickActionButton(
                                title: "Generate Meal Plan",
                                subtitle: "Get personalized recommendations",
                                icon: "fork.knife",
                                color: AppColors.forestGreen
                            ) {
                                // TODO: Navigate to meal planning
                            }
                            
                            QuickActionButton(
                                title: "Log Food",
                                subtitle: "Track your daily intake",
                                icon: "plus.circle",
                                color: AppColors.lightForestGreen
                            ) {
                                // TODO: Navigate to food logging
                            }
                            
                            QuickActionButton(
                                title: "View Progress",
                                subtitle: "Track your journey",
                                icon: "chart.line.uptrend.xyaxis",
                                color: AppColors.forestGreen
                            ) {
                                // TODO: Navigate to progress tracking
                            }
                        }
                        .padding(.horizontal, Spacing.lg)
                    }
                    
                    Spacer(minLength: 100) // Space for tab bar
                }
            }
            .background(AppColors.lightGreenTint)
            .navigationBarHidden(true)
        }
    }
    
    private func bmiCategory(_ bmi: Double) -> String {
        switch bmi {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Normal"
        case 25..<30: return "Overweight"
        default: return "Obese"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(value)
                    .font(AppTypography.headline())
                    .foregroundColor(AppColors.text)
                
                Text(title)
                    .font(AppTypography.caption(.semibold))
                    .foregroundColor(AppColors.text)
                
                Text(subtitle)
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Spacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .shadow(color: AppShadows.small, radius: 2, x: 0, y: 1)
    }
}

struct GoalCard: View {
    let goal: HealthImprovementGoal
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: goal.icon)
                .font(.title2)
                .foregroundColor(AppColors.forestGreen)
            
            Text(goal.displayName)
                .font(AppTypography.caption(.semibold))
                .foregroundColor(AppColors.text)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.md)
        .frame(width: 100, height: 80)
        .background(AppColors.cardBackground)
        .cornerRadius(CornerRadius.medium)
        .shadow(color: AppShadows.small, radius: 2, x: 0, y: 1)
    }
}

struct QuickActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(AppTypography.body(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    Text(subtitle)
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
            .shadow(color: AppShadows.small, radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Placeholder views for other tabs
struct NutritionView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: Spacing.lg) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.forestGreen)
                
                Text("Nutrition")
                    .font(AppTypography.headline())
                    .foregroundColor(AppColors.text)
                
                Text("Your personalized nutrition plans and recommendations will appear here.")
                    .font(AppTypography.body())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.lg)
            }
            .padding(Spacing.xl)
            .background(AppColors.lightGreenTint)
            .navigationBarHidden(true)
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    if let user = appStateManager.user {
                        // Profile Header
                        VStack(spacing: Spacing.md) {
                            Circle()
                                .fill(AppColors.forestGreen.opacity(0.2))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(AppColors.forestGreen)
                                )
                            
                            Text("Your Profile")
                                .font(AppTypography.headline())
                                .foregroundColor(AppColors.text)
                        }
                        .padding(.top, Spacing.lg)
                        
                        // Profile Details
                        VStack(spacing: Spacing.md) {
                            ProfileDetailRow(title: "Height", value: user.heightInFeetAndInches)
                            ProfileDetailRow(title: "Weight", value: user.weightInPounds)
                            ProfileDetailRow(title: "Age", value: "\(user.age) years")
                            ProfileDetailRow(title: "Gender", value: user.gender.displayName)
                            ProfileDetailRow(title: "Activity Level", value: user.activityLevel.displayName)
                            
                            if let targetWeight = user.targetWeightInPounds {
                                ProfileDetailRow(title: "Target Weight", value: targetWeight)
                            }
                            
                            ProfileDetailRow(title: "Weekly Budget", value: "$\(Int(user.weeklyBudget))")
                            
                            if user.healthKitData != nil {
                                ProfileDetailRow(title: "HealthKit", value: "Connected", isConnected: true)
                            }
                        }
                        .padding(Spacing.lg)
                        .background(AppColors.cardBackground)
                        .cornerRadius(CornerRadius.medium)
                        .shadow(color: AppShadows.small, radius: 2, x: 0, y: 1)
                        .padding(.horizontal, Spacing.lg)
                        
                        // Dietary Preferences
                        if !user.dietaryRestrictions.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.md) {
                                Text("Dietary Restrictions")
                                    .font(AppTypography.body(.semibold))
                                    .foregroundColor(AppColors.text)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: Spacing.sm) {
                                    ForEach(Array(user.dietaryRestrictions), id: \.self) { restriction in
                                        Text(restriction.displayName)
                                            .font(AppTypography.caption())
                                            .foregroundColor(AppColors.forestGreen)
                                            .padding(.horizontal, Spacing.sm)
                                            .padding(.vertical, Spacing.xs)
                                            .background(AppColors.forestGreen.opacity(0.1))
                                            .cornerRadius(CornerRadius.small)
                                    }
                                }
                            }
                            .padding(Spacing.lg)
                            .background(AppColors.cardBackground)
                            .cornerRadius(CornerRadius.medium)
                            .shadow(color: AppShadows.small, radius: 2, x: 0, y: 1)
                            .padding(.horizontal, Spacing.lg)
                        }
                    }
                    
                    Spacer(minLength: 100) // Space for tab bar
                }
            }
            .background(AppColors.lightGreenTint)
            .navigationBarHidden(true)
        }
    }
}

struct ProfileDetailRow: View {
    let title: String
    let value: String
    var isConnected: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.body())
                .foregroundColor(AppColors.text)
            
            Spacer()
            
            Text(value)
                .font(AppTypography.body())
                .foregroundColor(isConnected ? .green : AppColors.textSecondary)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppStateManager())
}
