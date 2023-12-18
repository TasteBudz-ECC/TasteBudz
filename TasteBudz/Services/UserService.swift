//
//  UserService.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser: User?
    static let shared = UserService()
    private static let userCache = NSCache<NSString, NSData>()

    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }

    static func fetchUser(withUid uid: String) async throws -> User {
        if let nsData = userCache.object(forKey: uid as NSString), let user = try? JSONDecoder().decode(User.self, from: nsData as Data) {
            return user
        }

        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        // Use 'if let' to safely unwrap the optional User object
        if let user = try? snapshot.data(as: User.self) {
            if let userData = try? JSONEncoder().encode(user) {
                userCache.setObject(userData as NSData, forKey: uid as NSString)
            }
            return user
        } else {
            throw NSError(domain: "UserService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
    }

    static func fetchUsers() async throws -> [User] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await FirestoreConstants.UserCollection.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) }).filter({ $0.id != uid })
    }

    static func fetchUsers(withUids uids: [String]) async throws -> [User] {
        var users = [User]()
        for uid in uids {
            let user = try await fetchUser(withUid: uid)
            users.append(user)
        }
        return users
    }

    func fetchUserFriends(_ uid: String) async throws -> [User] {
        guard let user = try? await UserService.fetchUser(withUid: uid) else { return [] }
        return try await UserService.fetchUsers(withUids: user.friendIds ?? [])
    }

    func fetchUserFriendNetwork(_ uid: String) async throws -> [User] {
        guard let user = try? await UserService.fetchUser(withUid: uid) else { return [] }
        return try await UserService.fetchUsers(withUids: user.friendNetworkIds ?? [])
    }
    
    func addFriend(currentUserId: String, friendUserId: String) async throws {
        let friendData = ["user1": currentUserId, "user2": friendUserId]
        try await FirestoreConstants.FriendsCollection.addDocument(data: friendData)

        await updateFriendAndNetworkCounts(currentUserId: currentUserId, affectedUserId: friendUserId, isAddingFriend: true)
    }

    func removeFriend(currentUserId: String, friendUserId: String) async throws {
        let query = FirestoreConstants.FriendsCollection
            .whereField("user1", isEqualTo: currentUserId)
            .whereField("user2", isEqualTo: friendUserId)
        try await deleteFriendship(query)
        try await deleteFriendship(query, reversed: true)

        await updateFriendAndNetworkCounts(currentUserId: currentUserId, affectedUserId: friendUserId, isAddingFriend: false)
    }

    private func deleteFriendship(_ query: Query, reversed: Bool = false) async throws {
        let querySnapshot = try await query.getDocuments()
        for document in querySnapshot.documents {
            try await document.reference.delete()
        }
    }

    private func updateFriendAndNetworkCounts(currentUserId: String, affectedUserId: String, isAddingFriend: Bool) async {
        try? await updateFriendCount(userId: currentUserId, isAddingFriend: isAddingFriend)
        try? await updateFriendCount(userId: affectedUserId, isAddingFriend: isAddingFriend)

        try? await updateFriendNetworkCount(userId: currentUserId)
        try? await updateFriendNetworkCount(userId: affectedUserId)

        let currentUserNetworkIds = await populateNetwork(forUserID: currentUserId)
        let affectedUserNetworkIds = await populateNetwork(forUserID: affectedUserId)
        var allAffectedUserIds = Set(currentUserNetworkIds).union(affectedUserNetworkIds)
        allAffectedUserIds.remove(currentUserId)
        allAffectedUserIds.remove(affectedUserId)

        for userId in allAffectedUserIds {
            try? await updateFriendNetworkCount(userId: userId)
        }
    }

    private func updateFriendCount(userId: String, isAddingFriend: Bool) async throws {
        let userDocRef = FirestoreConstants.UserCollection.document(userId)
        let userSnapshot = try await userDocRef.getDocument()
        if var userStats = try? userSnapshot.data(as: UserStats.self) {
            userStats.friendsCount += isAddingFriend ? 1 : -1
            try await userDocRef.updateData(["stats.friendsCount": userStats.friendsCount])
        }
    }

    private func updateFriendNetworkCount(userId: String) async throws {
        let networkIds = await populateNetwork(forUserID: userId)
        let userDocRef = FirestoreConstants.UserCollection.document(userId)
        try await userDocRef.updateData(["stats.friendNetworkCount": networkIds.count])
    }

    func checkIfUserIsFriends(_ profileUser: User) async -> Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let profileUserId = profileUser.id else {
            return false
        }
        let friendsCollection = FirestoreConstants.FriendsCollection
        do {
            let query = friendsCollection
                .whereField("user1", isEqualTo: currentUserId)
                .whereField("user2", isEqualTo: profileUserId)
            let snapshot = try await query.getDocuments()
            if !snapshot.documents.isEmpty {
                return true
            }
            
            let reverseQuery = friendsCollection
                .whereField("user1", isEqualTo: profileUserId)
                .whereField("user2", isEqualTo: currentUserId)
            let reverseSnapshot = try await reverseQuery.getDocuments()
            return !reverseSnapshot.documents.isEmpty
        } catch {
            print("Error in checkIfUserIsFriends: \(error)")
            return false
        }
    }

    func isUserInFriendNetwork(_ user: User) async -> Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let userIdToCheck = user.id else {
            return false
        }
        let friendsNetworkCollection = Firestore.firestore().collection("friend-network")
        do {
            let querySnapshot = try await friendsNetworkCollection
                .whereField("members", arrayContains: currentUserId)
                .whereField("members", arrayContains: userIdToCheck)
                .getDocuments()
            return !querySnapshot.documents.isEmpty
        } catch {
            print("Error fetching friend network: \(error)")
            return false
        }
    }

    func populateNetwork(forUserID userID: String) async -> [String] {
        var network = Set<String>()
        var visitedUsers = Set<String>()

        func fetchFriends(forUserID userID: String) async {
            guard !visitedUsers.contains(userID) else { return }
            visitedUsers.insert(userID)
            
            let friendsCollection = Firestore.firestore().collection("friends")
            let friendsQuery = friendsCollection.whereField("user1", isEqualTo: userID)
            
            do {
                let friendsSnapshot = try await friendsQuery.getDocuments()
                for document in friendsSnapshot.documents {
                    if let friendID = document["user2"] as? String {
                        network.insert(friendID)
                        await fetchFriends(forUserID: friendID)
                    }
                }
            } catch {
                print("Error fetching friends: \(error.localizedDescription)")
            }
        }

        await fetchFriends(forUserID: userID)
        return Array(network.subtracting([userID]))
    }
    // Update user profile for any user
      func updateUserProfile(userId: String, data: [String: Any]) async throws {
         let userDocRef = FirestoreConstants.UserCollection.document(userId)
         do {
             try await userDocRef.updateData(data)
             // Update cache if needed
         } catch {
             throw error
         }
     }
        func setupRealtimeUpdates() {
            guard let currentUserId = Auth.auth().currentUser?.uid else { return }

            FirestoreConstants.UserCollection.document(currentUserId)
                .addSnapshotListener { [weak self] snapshot, error in
                    guard let self = self, let snapshot = snapshot,
                          let user = try? snapshot.data(as: User.self) else { return }
                    DispatchQueue.main.async {
                        self.currentUser = user
                    }
                }
        }
}










// MARK: Feed Updates
 
// extension UserService {
//     //    func updateUserFeedAfterFollow(followedUid: String) async throws {
//     //        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//     //        let notesSnapshot = try await FirestoreConstants.NotesCollection.whereField("ownerUid", isEqualTo: followedUid).getDocuments()
//     //
//     //        for document in notesSnapshot.documents {
//     //            try await FirestoreConstants
//     //                .UserCollection
//     //                .document(currentUid)
//     //                .collection("user-feed")
//     //                .document(document.documentID)
//     //                .setData([:])
//     //        }
//     //    }
//     //
//     //    func updateUserFeedAfterUnfollow(unfollowedUid: String) async throws {
//     //        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//     //        let notesSnapshot = try await FirestoreConstants.NotesCollection.whereField("ownerUid", isEqualTo: unfollowedUid).getDocuments()
//     //
//     //        for document in notesSnapshot.documents {
//     //            try await FirestoreConstants
//     //                .UserCollection
//     //                .document(currentUid)
//     //                .collection("user-feed")
//     //                .document(document.documentID)
//     //                .delete()
//     //        }
//     //    }
//     // Update user feed after a user enters or leaves the friend network
//     func updateUserFeedAfterFriendNetworkChange(friendUid: String, added: Bool) async throws {
//         guard (Auth.auth().currentUser?.uid) != nil else { return }
//         // Logic to update feed based on whether the friend is added or removed from the network
//         // ...
//     }
// }
//
//// // MARK: - Helpers
//// extension UserService {
////     private static func fetchUsers(_ snapshot: QuerySnapshot?) async throws -> [User] {
////         var users = [User]()
////         guard let documents = snapshot?.documents else { return [] }
////
////         for doc in documents {
////             let user = try await UserService.fetchUser(withUid: doc.documentID)
////             users.append(user)
////         }
////
////         return users
////     }
//// }
//


// Define the FriendRequest struct if needed
//struct FriendRequest: Codable {
//    var from: String
//    var to: String
//    var status: String
//}

