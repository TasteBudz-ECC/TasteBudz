//
//  SettingsView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(SettingsOptions.allCases) { option in
                HStack {
                    Image(systemName: option.imageName)
                    
                    Text(option.title)
                        .font(.subheadline)
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
