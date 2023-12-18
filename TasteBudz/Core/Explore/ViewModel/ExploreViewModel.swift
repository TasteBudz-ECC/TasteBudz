//
//  ExploreViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var isLoading = false
    
    init() {
        Task { try await fetchUsers() }
    }
    
    func fetchUsers() async throws {
            self.isLoading = true
            let users = try await UserService.fetchUsers()
            
            try await withThrowingTaskGroup(of: User.self, body: { group in
                var result = [User]()
                
                for i in 0 ..< users.count {
                    group.addTask { return await self.checkIfUserIsFriends(user: users[i]) }
                }
                            
                for try await user in group {
                    result.append(user)
                }
                
                self.isLoading = false
                self.users = result
            })
        }
//    func fetchUsersInFriendNetwork() async {
//        isLoading = true
//        do {
//            guard let currentUserId = UserService.shared.currentUser?.id else {
//                isLoading = false
//                return
//            }
//            let friendNetworkUsers = try await UserService.shared.fetchUserFriendNetwork(currentUserId)
//            var updatedUsers = [User]()
//
//            try await withThrowingTaskGroup(of: User.self, body: { group in
//                for user in friendNetworkUsers {
//                    group.addTask { return await self.checkIfUserIsFriends(user: user) }
//                }
//
//                for try await updatedUser in group {
//                    updatedUsers.append(updatedUser)
//                }
//            })
//
//            DispatchQueue.main.async { [weak self] in
//                self?.users = updatedUsers
//                self?.isLoading = false
//            }
//        } catch {
//            print("Error fetching users in friend network: \(error)")
//            DispatchQueue.main.async { [weak self] in
//                self?.isLoading = false
//                // Handle the error as appropriate for your app
//            }
//        }
//    }

    func filteredUsers(_ query: String) -> [User] {
        let lowercasedQuery = query.lowercased()
        return users.filter {
            $0.fullname.lowercased().contains(lowercasedQuery) ||
            $0.username.lowercased().contains(lowercasedQuery)
        }
    }
    
    func checkIfUserIsFriends(user: User) async -> User {
        var result = user
        result.isFriends = await UserService.shared.checkIfUserIsFriends(user)
        return result
    }
}
