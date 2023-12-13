//
//  SettingsView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = AccountDeletionViewModel()
    @State private var showActionSheet = false


    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(SettingsOptions.allCases) { option in
                    NavigationLink(destination: option.destinationView) {
                        HStack {
                            Image(systemName: option.imageName)
                            
                            Text(option.title)
                                .font(.subheadline)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Divider()
                    
                    Button("Log Out") {
                        AuthService.shared.signOut()
                    }
                    .font(.subheadline)
                    .listRowSeparator(.hidden)
                    .padding(.top)
                }
                
//                Spacer()
//
             
//                    func logout() {
//                        session.logout()
//                    }
                
                Button(action: {
                    self.showActionSheet = true
                }) {
                    Text("Delete Account")
//                        .foregroundColor(.white)
                        .padding()
                }
//                .background(Color.gray)
                .cornerRadius(10)
                .padding(.trailing, 20)
                .actionSheet(isPresented: self.$showActionSheet) {
                    ActionSheet(title: Text("Delete"), message: Text("Are you sure you want to delete your account?"),
                        buttons: [
                            .default(Text("Yes, delete my account."), action: {
                                // Call your delete account function here
                                self.viewModel.deleteUser()
                                // Additional actions if needed, like logging out
                                AuthService.shared.signOut()
                                self.showActionSheet.toggle()
                            }),
                            .cancel()
                        ])
                }
                Spacer()
                

            }
            .padding()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.black)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
