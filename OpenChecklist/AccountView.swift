//
//  AccountView.swift
//  OpenChecklist
//
//  Created by Johan Oskarsson on 9/15/25.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var authManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()

                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text("Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    if let userID = authManager.userID {
                        Text("Signed in with Apple ID")
                            .font(.body)
                            .foregroundColor(.secondary)

                        Text("User ID: \(String(userID.prefix(8)))...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .monospaced()
                    } else {
                        Text("Signed in")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    Text("Your checklists are synced across all your devices with iCloud")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }

                Spacer()

                VStack(spacing: 15) {
                    Button {
                        authManager.signOut()
                        dismiss()
                    } label: {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}