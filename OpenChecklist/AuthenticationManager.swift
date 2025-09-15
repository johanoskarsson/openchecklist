//
//  AuthenticationManager.swift
//  OpenChecklist
//
//  Created by Johan Oskarsson on 9/15/25.
//

import Foundation
import AuthenticationServices
import CloudKit

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var userID: String?

    private let container = CKContainer(identifier: "iCloud.OpenChecklist")
    private let userDefaults = UserDefaults.standard
    private let signedInKey = "hasSignedInWithApple"
    private let userIDKey = "appleUserID"

    init() {
        print("🚀 AuthenticationManager initializing...")

        // Check if user was previously signed in
        loadAuthenticationState()

        // If they were signed in before, verify CloudKit status
        if isSignedIn {
            print("✅ User was previously signed in, checking CloudKit status...")
            checkAuthenticationStatus()
        } else {
            print("❌ No previous sign-in found")
        }
    }

    func checkAuthenticationStatus() {
        container.accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                print("☁️ CloudKit status: \(status)")
                switch status {
                case .available:
                    // CloudKit is available, keep current sign-in state
                    break
                case .noAccount, .restricted, .temporarilyUnavailable:
                    // If CloudKit isn't available but user signed in, keep them signed in
                    // They can still use the app locally
                    print("⚠️ CloudKit not available but keeping user signed in locally")
                case .couldNotDetermine:
                    print("⚠️ Could not determine CloudKit status")
                @unknown default:
                    print("⚠️ Unknown CloudKit status")
                }
            }
        }
    }

    func signInWithApple(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                userID = appleIDCredential.user
                isSignedIn = true
                saveAuthenticationState()
            }
        case .failure(let error):
            print("Sign in with Apple failed: \(error)")
            isSignedIn = false
        }
    }

    func signOut() {
        isSignedIn = false
        userID = nil
        clearAuthenticationState()
    }

    private func loadAuthenticationState() {
        isSignedIn = userDefaults.bool(forKey: signedInKey)
        userID = userDefaults.string(forKey: userIDKey)
        print("🔍 Loading auth state - isSignedIn: \(isSignedIn), userID: \(userID ?? "nil")")
    }

    func saveAuthenticationState() {
        userDefaults.set(isSignedIn, forKey: signedInKey)
        userDefaults.set(userID, forKey: userIDKey)
        print("💾 Saving auth state - isSignedIn: \(isSignedIn), userID: \(userID ?? "nil")")
    }

    private func clearAuthenticationState() {
        userDefaults.removeObject(forKey: signedInKey)
        userDefaults.removeObject(forKey: userIDKey)
    }
}