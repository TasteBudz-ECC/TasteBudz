//
//  RegistrationViewModel.swift
//  TasteBudz
//
//  Created by student on 11/30/23.
//

import FirebaseAuth

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    @Published var isAuthenticating = false
    @Published var showAlert = false
    @Published var authError: AuthError?
    @Published var inviteCode: String = ""
    
    @MainActor
    func createUser() async throws {
        isAuthenticating = true
        do {
            try await AuthService.shared.createUser(
                withEmail: email,
                password: password,
                fullname: fullname,
                username: username
            )
            isAuthenticating = false
        } catch {
            let authErrorCode = AuthErrorCode.Code(rawValue: (error as NSError).code)
            showAlert = true
            isAuthenticating = false
            authError = AuthError(authErrorCode: authErrorCode ?? .userNotFound)
        }
    }
}
