//
//  SignupLoginView.swift
//  TasteBudz
//
//  Created by Litao Li on 10/31/23.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SignupLoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
        var body: some View {
            NavigationStack {
                VStack {
                    // image logo would go here
                    Text("TasteBudz")
                    
                    //form fields
                    VStack(spacing: 24) {
                        InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                            .autocapitalization(.none)
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    // sign in button
                    Button(action: {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    }, label: {
                        HStack {
                            Text("SIGN IN")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    })
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .padding(.top, 24)
                    
                    Spacer()
                    // sign up button
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing: 3){
                            Text("Don't have an account?")
                            Text("Sign up")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                    }
                }
            }
        }
}

#Preview {
    SignupLoginView()
}
