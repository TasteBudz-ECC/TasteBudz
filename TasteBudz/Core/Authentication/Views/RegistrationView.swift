//
//  RegistrationView.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI
struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var hasSignedUp = false
    @State private var presented = false // State to manage the presentation of RequestUserContactsView
    @State private var shouldNavigate = false // State to manage navigation

    var body: some View {
        VStack {
            Spacer()
                        
                        // logo image
                        Image("GatherIcon_1024x1024")
                            // .renderingMode(.template)
                            .resizable()
                            // .colorMultiply(Color.theme.primaryText)
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding()
                        
                        // text fields
                        VStack {
                            TextField("Enter your email", text: $viewModel.email)
                                .autocapitalization(.none)
                                .modifier(NotesTextFieldModifier())
                            
                            SecureField("Enter your password", text: $viewModel.password)
                                .modifier(NotesTextFieldModifier())
                            
                            TextField("Enter your full name", text: $viewModel.fullname)
                                .autocapitalization(.none)
                                .modifier(NotesTextFieldModifier())
                            
                            TextField("Enter your username", text: $viewModel.username)
                                .autocapitalization(.none)
                                .modifier(NotesTextFieldModifier())
                        }


            Button {
                Task {
                    try await signUpAndInviteContacts()
                }
            } label: {
                Text(viewModel.isAuthenticating ? "" : "Sign up")
                    .foregroundColor(Color.theme.primaryBackground)
                    .modifier(NotesButtonModifier())
                    .overlay {
                        if viewModel.isAuthenticating {
                            ProgressView()
                                .tint(Color.theme.primaryBackground)
                        }
                    }
            }
            .disabled(viewModel.isAuthenticating || !formIsValid)
            .opacity(formIsValid ? 1 : 0.7)
            .padding(.vertical)

            Spacer()

            Divider()

            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color.theme.primaryText)
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.authError?.description ?? ""))
        }
        .background(
            Text("")
                .hidden()
                .navigationDestination(isPresented: $shouldNavigate) {
                    RequestUserContactsView()
                    Text("") // Optionally, use hidden text for better readability or as needed
                        .hidden()
                }
        )
        .onChange(of: shouldNavigate) { newValue in
            // Reset the navigation flag after navigation
            if newValue {
                shouldNavigate = false
            }
        }


//        .fullScreenCover(isPresented: $hasSignedUp) {
//            RequestUserContactsView()
//        }
//        .sheet(isPresented: $presented) {
//                    RequestUserContactsView()
//            }
    }

    // Function to sign up and initiate contacts invitation
    func signUpAndInviteContacts() async {
        do {
            // Sign up the user
            try await viewModel.createUser()
            hasSignedUp = true // Set flag to navigate to contacts invitation view
            shouldNavigate = true // Trigger navigation to RequestUserContactsView
        } catch {
            print("Error signing up: \(error.localizedDescription)")
            // Handle sign up error
        }
    }

    // MARK: - Form Validation

    var formIsValid: Bool {
        return !viewModel.email.isEmpty
            && viewModel.email.contains("@")
            && !viewModel.password.isEmpty
            && !viewModel.fullname.isEmpty
            && viewModel.password.count > 5
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

