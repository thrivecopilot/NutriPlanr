import SwiftUI
import HealthKit

struct HealthKitStepView: View {
    @Binding var userProfile: UserProfile
    @State private var isAuthorized = false
    @State private var isSyncing = false
    @State private var syncComplete = false
    @State private var syncError: String?
    
    // Add callback for auto-advancing
    let onSyncComplete: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Header - More compact
            VStack(spacing: Spacing.sm) {
                Text("Sync with Apple Health")
                    .font(AppTypography.headline())
                    .foregroundColor(AppColors.text)
                    .multilineTextAlignment(.center)
                
                Text("We'll automatically import your health data to create a personalized plan")
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if !isAuthorized && !syncComplete {
                // Authorization Request - More compact
                VStack(spacing: Spacing.lg) {
                    Image(systemName: "heart.text.square")
                        .font(.system(size: 50))
                        .foregroundColor(AppColors.primary)
                    
                    VStack(spacing: Spacing.sm) {
                        Text("Connect to Apple Health")
                            .font(AppTypography.title(.semibold))
                            .foregroundColor(AppColors.text)
                            .multilineTextAlignment(.center)
                        
                        Text("This allows us to access your health data to provide personalized nutrition recommendations")
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: requestHealthKitAccess) {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "heart.fill")
                                .font(.title3)
                            
                            Text("Connect Apple Health")
                                .font(AppTypography.body(.semibold))
                        }
                        .foregroundColor(.white)
                        .padding(Spacing.lg)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.primary)
                        .cornerRadius(CornerRadius.medium)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(Spacing.xl)
                .background(AppColors.cardBackground)
                .cornerRadius(CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .stroke(AppColors.border, lineWidth: 1)
                )
                .shadow(color: AppShadows.small, radius: 8, x: 0, y: 4)
            }
            
            if isAuthorized && !syncComplete {
                // Syncing Data - More compact
                VStack(spacing: Spacing.lg) {
                    if isSyncing {
                        ProgressView()
                            .scaleEffect(1.2)
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primary))
                        
                        Text("Syncing your health data...")
                            .font(AppTypography.body(.semibold))
                            .foregroundColor(AppColors.text)
                    }
                }
                .padding(Spacing.xl)
                .background(AppColors.cardBackground)
                .cornerRadius(CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .stroke(AppColors.border, lineWidth: 1)
                )
            }
            
            if syncComplete {
                // Sync Results - More compact
                VStack(spacing: Spacing.lg) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    Text("Data Synced Successfully!")
                        .font(AppTypography.title(.semibold))
                        .foregroundColor(AppColors.text)
                    
                    // Show imported data - More compact
                    VStack(spacing: Spacing.sm) {
                        if userProfile.height > 0 {
                            let feet = Int(userProfile.height / 12)
                            let inches = Int(userProfile.height.truncatingRemainder(dividingBy: 12))
                            DataRow(label: "Height", value: "\(feet)'\(inches)\"")
                        }
                        if userProfile.weight > 0 {
                            DataRow(label: "Weight", value: "\(Int(userProfile.weight)) lbs")
                        }
                        if userProfile.age > 0 {
                            DataRow(label: "Age", value: "\(userProfile.age) years")
                        }
                        if userProfile.gender != .other {
                            DataRow(label: "Gender", value: userProfile.gender.displayName)
                        }
                        if userProfile.activityLevel != .moderate {
                            DataRow(label: "Activity Level", value: userProfile.activityLevel.displayName)
                        }
                    }
                    .padding(Spacing.lg)
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(CornerRadius.medium)
                    
                    // Auto-advance button
                    Button(action: onSyncComplete) {
                        HStack(spacing: Spacing.sm) {
                            Text("Continue")
                                .font(AppTypography.body(.semibold))
                            
                            Image(systemName: "arrow.right")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                        .padding(Spacing.lg)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.primary)
                        .cornerRadius(CornerRadius.medium)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(Spacing.xl)
                .background(AppColors.cardBackground)
                .cornerRadius(CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .stroke(AppColors.border, lineWidth: 1)
                )
                .shadow(color: AppShadows.small, radius: 8, x: 0, y: 4)
            }
            
            if let error = syncError {
                // Error State - More compact
                VStack(spacing: Spacing.lg) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    VStack(spacing: Spacing.sm) {
                        Text("Sync Issue")
                            .font(AppTypography.title(.semibold))
                            .foregroundColor(AppColors.text)
                        
                        Text(error)
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Try Again") {
                        syncError = nil
                        requestHealthKitAccess()
                    }
                    .foregroundColor(AppColors.primary)
                    .padding(Spacing.lg)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(CornerRadius.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                            .stroke(AppColors.primary, lineWidth: 1)
                    )
                }
                .padding(Spacing.xl)
                .background(AppColors.cardBackground)
                .cornerRadius(CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .stroke(AppColors.border, lineWidth: 1)
                )
                .shadow(color: AppShadows.small, radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
        .onAppear {
            checkHealthKitStatus()
        }
    }
    
    private func checkHealthKitStatus() {
        let healthKitService = HealthKitService()
        healthKitService.checkAuthorization { authorized in
            DispatchQueue.main.async {
                self.isAuthorized = authorized
                if authorized {
                    self.syncHealthKitData()
                }
            }
        }
    }
    
    private func requestHealthKitAccess() {
        let healthKitService = HealthKitService()
        healthKitService.requestAuthorization { success in
            DispatchQueue.main.async {
                if success {
                    self.isAuthorized = true
                    self.syncHealthKitData()
                } else {
                    self.syncError = "Unable to access Apple Health. Please check your privacy settings."
                }
            }
        }
    }
    
    private func syncHealthKitData() {
        isSyncing = true
        let healthKitService = HealthKitService()
        
        healthKitService.fetchUserData { healthData in
            DispatchQueue.main.async {
                self.isSyncing = false
                
                // Update user profile with HealthKit data
                if let height = healthData.height {
                    self.userProfile.height = height
                }
                if let weight = healthData.weight {
                    self.userProfile.weight = weight
                }
                if let age = healthData.age {
                    self.userProfile.age = age
                }
                if let gender = healthData.gender {
                    self.userProfile.gender = gender
                }
                
                // Estimate activity level from HealthKit data
                self.estimateActivityLevel()
                
                self.syncComplete = true
                
                // Auto-advance after a short delay to show the success state
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.onSyncComplete()
                }
            }
        }
    }
    
    private func estimateActivityLevel() {
        // TODO: Implement activity level estimation from HealthKit data
        // For now, keep the default moderate level
        // This could be enhanced with step count, active energy, workout data
    }
}

struct DataRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppTypography.caption(.semibold))
                .foregroundColor(AppColors.text)
        }
    }
}

#Preview {
    HealthKitStepView(userProfile: .constant(UserProfile()), onSyncComplete: {})
}
