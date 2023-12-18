//
//  UserRelationsViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import FirebaseFirestore
import Firebase

@MainActor
class UserRelationsViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var currentStatString: String = ""
    @Published var selectedFilter: UserRelationType = .friends {
        didSet { updateRelationData() }
    }
    
    private let user: User
    private var friends = [User]()
    private var friendNetwork = [User]()

    init(user: User) {
        self.user = user
        Task { await fetchUserRelations() }
    }
    
    private func fetchUserRelations() {
        guard let userId = UserService.shared.currentUser?.id else { return }
        Task { await fetchUserFriendsAndNetwork(userId: userId) }
    }

    private func fetchUserFriendsAndNetwork(userId: String) async {
        do {
            async let fetchedFriends = UserService.shared.fetchUserFriends(userId) // Removed the label
            async let fetchedNetwork = UserService.shared.fetchUserFriendNetwork(userId) // Removed the label

            self.friends = try await fetchedFriends
            self.friendNetwork = try await fetchedNetwork
            updateRelationData()
        } catch {
            print("Error fetching user relations: \(error)")
            // Consider how to handle and communicate this error
        }
    }


    private func updateRelationData() {
        switch selectedFilter {
        case .friends:
            self.users = friends
        case .friendNetwork:
            self.users = friendNetwork
        }
        self.currentStatString = "\(self.users.count) \(selectedFilter.title.lowercased())"
    }

    private func fetchUsers(with ids: [String]) async throws -> [User] {
        try await withThrowingTaskGroup(of: User?.self) { group in
            for id in ids {
                group.addTask { try? await UserService.fetchUser(withUid: id) }
            }
            var fetchedUsers = [User]()
            for try await user in group {
                if let user = user {
                    fetchedUsers.append(user)
                }
            }
            return fetchedUsers
        }
    }
}
