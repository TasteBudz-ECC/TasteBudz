//
//  UserProfileViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import Firebase

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var notes = [Note]() // Assuming 'Note' is a defined struct/class
    @Published var replies = [NoteReply]() // Assuming 'NoteReply' is a defined struct/class
    @Published var user: User
    @Published var friends = [User]()
    @Published var friendNetwork = [User]()
    @Published var friendStatus = UserFriendStatus.notFriends

    init(user: User) {
        self.user = user
        loadUserData()
    }
//    var id: Int { return self.rawValue }

    func loadUserData() {
        Task {
            async let fetchedFriends = UserService.shared.fetchUserFriends(user.id ?? "")
            async let fetchedFriendNetwork = UserService.shared.fetchUserFriendNetwork(user.id ?? "")
            // Include logic to fetch notes and replies if applicable.
            do {
                self.friends = try await fetchedFriends
                self.friendNetwork = try await fetchedFriendNetwork
                // Process notes and replies here.
            } catch {
                // Consider better error handling
                print("Error loading user data: \(error)")
            }
            await checkFriendshipStatus()
        }
    }

    func checkFriendshipStatus() async {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let profileUserId = user.id, currentUserId != profileUserId else {
            self.friendStatus = .notFriends
            return
        }
        do {
            let isFriend = await UserService.shared.checkIfUserIsFriends(user)
            self.friendStatus = isFriend ? .friends : .notFriends
        } catch {
            print("Error checking friendship status: \(error)")
        }
    }

    func addFriend() async {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let profileUserId = user.id, currentUserId != profileUserId else { return }
        do {
            try await UserService.shared.addFriend(currentUserId: currentUserId, friendUserId: profileUserId)
            await fetchFriends()
            self.friendStatus = .friends
            self.user.stats?.friendsCount += 1
        } catch {
            print("Error adding friend: \(error)")
        }
    }

    func removeFriend() async {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let profileUserId = user.id, currentUserId != profileUserId else { return }
        do {
            try await UserService.shared.removeFriend(currentUserId: currentUserId, friendUserId: profileUserId)
            await fetchFriends()
            self.friendStatus = .notFriends
            self.user.stats?.friendsCount -= 1
        } catch {
            print("Error removing friend: \(error)")
        }
    }

    func fetchFriends() async {
        guard let userId = user.id else { return }
        do {
            self.friends = try await UserService.shared.fetchUserFriends(userId)
        } catch {
            print("Error fetching friends: \(error)")
        }
    }

    func fetchFriendNetwork() async {
        guard let userId = user.id else { return }
        do {
            self.friendNetwork = try await UserService.shared.fetchUserFriendNetwork(userId)
        } catch {
            print("Error fetching friend network: \(error)")
        }
    }
}

enum UserFriendStatus {
    case friends, notFriends
    var buttonText: String {
        switch self {
        case .friends: return "Unfriend"
        case .notFriends: return "Add Friend"
        }
    }
}

// Assuming the existence of UserRelationType
//enum UserRelationType: Int, CaseIterable, Identifiable {
//    case friends
//    case friendNetwork
//    
//    var title: String {
//        switch self {
//        case .friends: return "Friends"
//        case .friendNetwork: return "Friend Network"
//        }
//    }



