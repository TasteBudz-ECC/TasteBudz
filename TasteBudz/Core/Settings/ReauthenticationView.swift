//
//  ReauthenticationView.swift
//  TasteBudz
//
//  Created by student on 12/15/23.
//

import SwiftUI

struct ReauthenticationView: View {
    @Binding var isPresented: Bool
    var onReauthenticationSuccess: () -> Void

    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if showError {
                    Text("Reauthentication failed. Please try again.")
                        .foregroundColor(.red)
                        .padding()
                }

                Button("Reauthenticate") {
                    isLoading = true
                    showError = false
                    reauthenticateUser()
                }
                .padding()
            }
        }
        .padding()
    }

    private func reauthenticateUser() {
        Task {
            do {
                try await AuthService.shared.reauthenticate(password: password)
                onReauthenticationSuccess()
            } catch {
                showError = true
            }
            isLoading = false
            isPresented = false
        }
    }
}

struct ReauthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        ReauthenticationView(isPresented: .constant(true), onReauthenticationSuccess: {})
    }
}

