//
//  ProfileHeaderView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    var user: User?
    init(user: User?) {
        self.user = user
    }
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                // this v stack is for bio and stats
                VStack(alignment: .leading, spacing: 4) {
                    // this is for full name and username
                    Text(user?.fullname ?? "")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(user?.username ?? "")
                        .font(.subheadline)
                }
                
                if let bio = user?.bio {
                    Text(bio)
                        .font(.footnote)
                }
                
                Text("2 followers")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            CircularProfileImageView()
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(user: dev.user)
    }
}
