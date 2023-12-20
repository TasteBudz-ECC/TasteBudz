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
    
    private let userService = UserService.shared

    init() {
        Task { try await fetchUsers() }
    }
    
    func fetchUsers() async throws {
           self.isLoading = true
           let allUsers = try await UserService.fetchUsers()
           
           try await withThrowingTaskGroup(of: User.self, body: { group in
               var result = [User]()
               
               for user in allUsers {
                   group.addTask { [weak self] in
                       guard let self = self else { return user }
                       return await self.checkIfUserIsFriend(user: user)
                   }
               }
                           
               for try await user in group {
                   result.append(user)
               }
               
               self.isLoading = false
               self.users = result
           })
       }
    
    func filteredUsers(_ query: String) -> [User] {
        let lowercasedQuery = query.lowercased()
        return users.filter({
            $0.fullname.lowercased().contains(lowercasedQuery) ||
            $0.username.lowercased().contains(lowercasedQuery)
        })
    }
    
    func checkIfUserIsFriend(user: User) async -> User {
            var result = user
            result.isFriends = await userService.checkIfUserIsFriend(uid: user.id)
            return result
            }
    }
                                            
