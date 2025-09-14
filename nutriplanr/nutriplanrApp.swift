//
//  nutriplanrApp.swift
//  nutriplanr
//
//  Created by Dave Mathew on 8/31/25.
//

import SwiftUI

@main
struct nutriplanrApp: App {
    // MARK: - State Management
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStateManager)
        }
    }
}
