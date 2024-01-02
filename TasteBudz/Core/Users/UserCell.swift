//
//  UserCell.swift
//  TasteBudz
//
//  Created by student on 11/30/23.
//

import SwiftUI

struct UserCell: View {
    @StateObject var viewModel: UserProfileViewModel
    let user: User

    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: UserProfileViewModel(user: user))
    }

    private var isFriend: Bool {
        viewModel.user.isFriends ?? false
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                CircularProfileImageView(user: user, size: .small)

                VStack(alignment: .leading) {
                    Text(user.username)
                        .bold()

                    Text(user.fullname)
                }
                .font(.footnote)

                Spacer()

                if !user.isCurrentUser {
                    Button {
                        handleFriendTapped()
                    } label: {
                        Text(isFriend ? "Remove Friend" : "Add Friend")
                            .foregroundStyle(isFriend ? Color(.systemGray4) : Color.theme.primaryText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 100, height: 32)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                    }
                }
            }
            .padding(.horizontal)

            Divider()
        }
        .padding(.vertical, 4)
        .foregroundColor(.black)
        // .foregroundColor(Color.theme.primaryText)
    }

    func handleFriendTapped() {
        Task {
            do {
                if isFriend {
                    try await viewModel.removeFriend()
                } else {
                    try await viewModel.addFriend()
                }
            } catch {
                // Handle any errors here
            }
        }
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: dev.user)
    }
}
