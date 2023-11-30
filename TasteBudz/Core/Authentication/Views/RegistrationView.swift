//
//  RegistrationView.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var username = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Spacer()
            
            Image("GatherIcon_1024x1024")
            // could add the other image here instead
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .padding()
            
            VStack {
                TextField("Enter your email", text: $email)
                    .modifier(NotesTextFieldModifier())
                
                SecureField("Enter your password", text: $password)
                    .modifier(NotesTextFieldModifier())
                
                TextField("Enter your full name", text: $fullname)
                    .modifier(NotesTextFieldModifier())
                
                TextField("Enter your username", text: $username)
                    .modifier(NotesTextFieldModifier())
                
            }
            
            Button {
                
            } label: {
                Text("Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 352, height: 44)
                    .background(.black)
                    .cornerRadius(8)
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
               dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .font(.footnote)
            }
            .padding(.vertical, 16)

        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
