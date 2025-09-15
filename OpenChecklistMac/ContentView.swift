//
//  ContentView.swift
//  OpenChecklistMac
//
//  Created by Johan Oskarsson on 9/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        ChecklistListView()
            .environmentObject(authManager)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
        .modelContainer(for: [Checklist.self, ChecklistItem.self], inMemory: true)
}
