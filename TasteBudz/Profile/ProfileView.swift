//
//  ProfileView.swift
//  TasteBudz
//
//  Created by student on 11/4/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedThreadFilter: ProfileNoteFilterViewModel = .notes
    @ObservedObject var viewModel: UserProfileViewModel
    @State private var showUserRelationSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(user: User) {
        self._viewModel = ObservedObject(wrappedValue: UserProfileViewModel(user: user))
    }

    private var user: User {
        return viewModel.user
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                profileHeader
                friendButton
                UserContentListView(
                    selectedFilter: $selectedThreadFilter,
                    user: user
                )
            }
            .sheet(isPresented: $showUserRelationSheet) {
                UserRelationsView(user: user)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .onAppear {
            Task { await viewModel.checkFriendshipStatus() }
        }
    }

    private var profileHeader: some View {
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
    }

    private var friendButton: some View {
        Button(action: handleFriendButtonTapped) {
            Text(viewModel.friendStatus.buttonText)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .frame(width: 352, height: 32)
                .background(Color.blue)
                .cornerRadius(8)
        }
        .onChange(of: viewModel.friendStatus) { newStatus in
            switch newStatus {
            case .friends:
                showMessage("You are now friends with \(user.username)")
                Task { await viewModel.fetchFriends() }

            case .notFriends:
                showMessage("You are no longer friends with \(user.username)")
                Task { await viewModel.fetchFriends() }
            }
        }
    }

    func handleFriendButtonTapped() {
        Task {
            switch viewModel.friendStatus {
            case .notFriends:
                try await viewModel.addFriend()
            case .friends:
                try await viewModel.removeFriend()
            }
        }
    }

    private func showMessage(_ message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}

