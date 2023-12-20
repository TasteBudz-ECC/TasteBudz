//
//  UserRelationsViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

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
        Task { try await fetchUserFriends() }
        Task { try await fetchUserFriendNetwork() }
    }
    
    private func fetchUserFriends() async throws {
        let friendIDs = try await UserService.shared.fetchFirstDegreeFriends(forUserID: user.id)
        self.friends = try await fetchUsers(from: friendIDs)
        self.updateRelationData()
    }
    
    private func fetchUserFriendNetwork() async throws {
        let friendNetworkIDs = try await UserService.fetchSecondDegreeFriends(forUserID: user.id)
        self.friendNetwork = try await fetchUsers(from: friendNetworkIDs)
        self.updateRelationData()
    }
    
    private func updateRelationData() {
        switch selectedFilter {
        case .friends:
            self.users = friends
            self.currentStatString = "\(friends.count) friends"
        case .friendNetwork:
            self.users = friendNetwork
            self.currentStatString = "\(friendNetwork.count) in friend network"
        }
    }

    private func fetchUsers(from ids: Set<String>) async throws -> [User] {
        var users = [User]()
        for id in ids {
            let user = try await UserService.fetchUser(withUid: id)
            users.append(user)
        }
        return users
    }
}

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
//    
//    var id: Int { return self.rawValue }
//}

