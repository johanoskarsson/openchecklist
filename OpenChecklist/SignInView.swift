//
//  SignInView.swift
//  OpenChecklist
//
//  Created by Johan Oskarsson on 9/15/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @ObservedObject var authManager: AuthenticationManager

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "checklist")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("OpenChecklist")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Sign in to sync your checklists across all your devices with iCloud")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }

            Spacer()

            VStack(spacing: 20) {
                SignInWithAppleButton { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    authManager.signInWithApple(result: result)
                    if case .success = result {
                        authManager.checkAuthenticationStatus()
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
