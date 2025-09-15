//
//  OpenChecklistMacApp.swift
//  OpenChecklistMac
//
//  Created by Johan Oskarsson on 9/15/25.
//

import SwiftUI
import SwiftData

@main
struct OpenChecklistMacApp: App {
    @StateObject private var authManager = AuthenticationManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Checklist.self,
            ChecklistItem.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier("group.nu.oskarsson.OpenChecklist"),
            cloudKitDatabase: .automatic,
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if authManager.isSignedIn {
                ContentView()
                    .environmentObject(authManager)
            } else {
                SignInView(authManager: authManager)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
