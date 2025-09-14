import Foundation
import SwiftUI

@MainActor
class AppStateManager: ObservableObject {
    @Published var isOnboardingComplete: Bool = false
    @Published var currentOnboardingStep: Int = 0
    @Published var totalOnboardingSteps: Int = 8
    
    // User preferences
    @Published var user: User?
    
    init() {
        // Load saved state if available
        loadAppState()
    }
    
    func completeOnboarding() {
        isOnboardingComplete = true
        saveAppState()
    }
    
    func resetOnboarding() {
        isOnboardingComplete = false
        currentOnboardingStep = 0
        saveAppState()
    }
    
    func updateOnboardingStep(_ step: Int) {
        currentOnboardingStep = step
        saveAppState()
    }
    
    func updateUser(_ user: User) {
        self.user = user
        saveAppState()
    }
    
    private func saveAppState() {
        // Save to UserDefaults
        UserDefaults.standard.set(isOnboardingComplete, forKey: "isOnboardingComplete")
        UserDefaults.standard.set(currentOnboardingStep, forKey: "currentOnboardingStep")
        
        // Save user data if available
        if let user = user {
            if let encoded = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encoded, forKey: "userData")
            }
        }
    }
    
    private func loadAppState() {
        isOnboardingComplete = UserDefaults.standard.bool(forKey: "isOnboardingComplete")
        currentOnboardingStep = UserDefaults.standard.integer(forKey: "currentOnboardingStep")
        
        // Load user data if available
        if let data = UserDefaults.standard.data(forKey: "userData"),
           let decodedUser = try? JSONDecoder().decode(User.self, from: data) {
            user = decodedUser
        }
    }
}

