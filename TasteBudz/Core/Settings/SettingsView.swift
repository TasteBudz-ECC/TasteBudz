//
//  SettingsView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct SettingsView: View {
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
