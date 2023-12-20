//
//  UserProfileViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var notes = [Note]()
    @Published var replies = [NoteReply]()
    @Published var user: User
    
    init(user: User) {
        self.user = user
        loadUserData()
    }
        
    func loadUserData() {
        Task {
            async let stats = try await UserService.fetchUserStats(uid: user.id)
            self.user.stats = try await stats

            async let isFriend = await checkIfUserIsFriend()
            self.user.isFriends = await isFriend
        }
    }
}

// MARK: - Friends Management

extension UserProfileViewModel {
    func addFriend() async throws {
        try await UserService.shared.addFriend(uid: user.id)
        self.user.isFriends = true
        // Update the current user's friend count
        await updateUserStats()
    }
    
    func removeFriend() async throws {
        try await UserService.shared.removeFriend(uid: user.id)
        self.user.isFriends = false
        // Update the current user's friend count
        await updateUserStats()
    }
    
    func checkIfUserIsFriend() async -> Bool {
        return await UserService.shared.checkIfUserIsFriend(uid: user.id)
    }

    private func updateUserStats() async {
        do {
            let updatedStats = try await UserService.fetchUserStats(uid: user.id)
            DispatchQueue.main.async {
                self.user.stats = updatedStats
            }
        } catch {
            // Handle error
        }
    }
}

