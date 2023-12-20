//
//  ProfileView.swift
//  TasteBudz
//
//  Created by student on 11/4/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedThreadFilter: ProfileNoteFilterViewModel = .notes
    @State private var showEditProfile = false
    @StateObject var viewModel: UserProfileViewModel
    @State private var showUserRelationSheet = false
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserProfileViewModel(user: user))
    }
    
    private var isFriend: Bool {
        return viewModel.user.isFriends ?? false
    }
    
    private var user: User {
        return viewModel.user
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(user.username)
                                .font(.subheadline)
                        }
                        
                        if let bio = user.bio {
                            Text(bio)
                                .font(.footnote)
                        }
                        
                        Button {
                            showUserRelationSheet.toggle()
                        } label: {
                            Text("\(user.stats?.friendsCount ?? 0) friends")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    CircularProfileImageView(user: user, size: .medium)
                }
                
                Button {
                    handleFriendTapped()
                } label: {
                    Text(isFriend ? "Remove Friend" : "Add Friend")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(isFriend ? Color.theme.primaryText : Color.theme.primaryBackground)
                        .frame(width: 352, height: 32)
                        .background(isFriend ? Color.theme.primaryBackground : Color.theme.primaryText)
                        .cornerRadius(8)
                        .overlay {
                            if isFriend {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                        }
                }
                
                UserContentListView(
                    selectedFilter: $selectedThreadFilter,
                    user: user
                )
            }
            .sheet(isPresented: $showUserRelationSheet) {
                UserRelationsView(user: user)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
    }
    
    func handleFriendTapped() {
        Task {
            if isFriend {
                try await viewModel.removeFriend()
            } else {
                try await viewModel.addFriend()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}

