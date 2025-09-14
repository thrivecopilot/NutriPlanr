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
                // Main app content - Home Page
                HomeView()
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
