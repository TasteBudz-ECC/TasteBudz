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
        if let nsData = userCache.object(forKey: uid as NSString) {
            if let user = try? JSONDecoder().decode(User.self, from: nsData as Data) {
                return user
            }
        }
        
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        
        if let userData = try? JSONEncoder().encode(user) {
            userCache.setObject(userData as NSData, forKey: uid as NSString)
        }
        
        return user
    }
    
    static func fetchUsers() async throws -> [User] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await FirestoreConstants.UserCollection.getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        return users.filter({ $0.id != uid })
    }
    
    // MARK: - Friends Management
    @MainActor
    func addFriend(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Add friend to 'friends' collection
        try await FirestoreConstants
            .FriendsCollection
            .document(currentUid)
            .collection("user-friends")
            .document(uid)
            .setData([:])
        
        // Update current user's stats
        currentUser?.stats?.friendsCount += 1
        await updateUserNetwork(forUserID: currentUid)
    }
    
    @MainActor
    func removeFriend(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Remove friend from 'friends' collection
        try await FirestoreConstants
            .FriendsCollection
            .document(currentUid)
            .collection("user-friends")
            .document(uid)
            .delete()
        
        // Update current user's stats
        currentUser?.stats?.friendsCount -= 1
        await updateUserNetwork(forUserID: currentUid)
    }
    
    func checkIfUserIsFriend(uid: String) async -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        let snapshot = try? await FirestoreConstants
            .FriendsCollection
            .document(currentUid)
            .collection("user-friends")
            .document(uid)
            .getDocument()
        return snapshot?.exists ?? false
    }
    static func checkIfUserIsFriendWithUid(_ uid: String) async -> Bool {
            guard let currentUid = Auth.auth().currentUser?.uid else { return false }
            let collection = FirestoreConstants.FriendsCollection.document(currentUid).collection("user-friends")
            guard let snapshot = try? await collection.document(uid).getDocument() else { return false }
            return snapshot.exists
        }
    // MARK: - Check Second Degree Connection
    
    @MainActor
    func isUserInSecondDegreeNetwork(ofUserID userID: String, checkUserID: String) async -> Bool {
        do {
            let firstDegreeFriends = try await UserService.shared.fetchFirstDegreeFriends(forUserID: userID)
            
            // If the checkUserID is already a first-degree friend, return false.
            if firstDegreeFriends.contains(checkUserID) {
                return false
            }
            
            let secondDegreeFriends = try await UserService.fetchSecondDegreeFriends(forUserID: userID)
            
            // Check if the checkUserID is within the second-degree network.
            return secondDegreeFriends.contains(checkUserID)
        } catch {
            // Handle error or return false
            return false
        }
    }
    // MARK: - Network Management
    
    func fetchFirstDegreeFriends(forUserID userID: String) async -> Set<String> {
        let db = Firestore.firestore()
        let friendsCollection = db.collection("friends").document(userID).collection("user-friends")
        let snapshot = try? await friendsCollection.getDocuments()
        let friends = snapshot?.documents.map { $0.documentID } ?? []

        return Set(friends)
    }
    
    // Use an instance of UserService to call the instance method
    static func fetchSecondDegreeFriends(forUserID userID: String) async throws -> Set<String> {
        let serviceInstance = UserService()
        var secondDegreeFriends = Set<String>()
        let firstDegreeFriends = try await serviceInstance.fetchFirstDegreeFriends(forUserID: userID)

        try await withThrowingTaskGroup(of: Result<Set<String>, Error>.self) { group in
            for friendID in firstDegreeFriends {
                group.addTask {
                    do {
                        let friends = try await serviceInstance.fetchFirstDegreeFriends(forUserID: friendID)
                        return .success(friends)
                    } catch {
                        return .failure(error)
                    }
                }
            }
            for try await result in group {
                switch result {
                case .success(let friendSet):
                    secondDegreeFriends.formUnion(friendSet)
                case .failure(let error):
                    throw error
                }
            }
        }
        // Exclude the current user and first-degree friends
        secondDegreeFriends.remove(userID)
        secondDegreeFriends.subtract(firstDegreeFriends)
        return secondDegreeFriends
    }


    
    @MainActor
    func updateUserNetwork(forUserID userID: String) async {
        do {
            let firstDegreeFriends = try await UserService.shared.fetchFirstDegreeFriends(forUserID: userID)
            let secondDegreeFriends = try await UserService.fetchSecondDegreeFriends(forUserID: userID)
            
            DispatchQueue.main.async {
                self.currentUser?.stats?.friendsCount = firstDegreeFriends.count
                self.currentUser?.stats?.friendNetworkCount = firstDegreeFriends.count + secondDegreeFriends.count
            }
        } catch {
            // Handle errors appropriately
            print("User network not updated")
        }
    }
    // MARK: - Feed Updates
    
    func updateUserFeedAfterAddingFriend(addedFriendUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Add User 2's posts to current user's feed
        try await addFriendPostsToFeed(currentUserId: currentUid, friendId: addedFriendUid)
        
        // Fetch User 2's first-degree UserService.friends
        let firstDegreeFriends = await fetchFirstDegreeFriends(forUserID: addedFriendUid)
        
        // Add posts of User 2's friends to current user's feed
        for friendId in firstDegreeFriends {
            try await addFriendPostsToFeed(currentUserId: currentUid, friendId: friendId)
        }
    }
    
    func addFriendPostsToFeed(currentUserId: String, friendId: String) async throws {
        let friendNotesCollection = Firestore.firestore().collection("notes").whereField("ownerUid", isEqualTo: friendId)
        let notesSnapshot = try await friendNotesCollection.getDocuments()
        
        for document in notesSnapshot.documents {
            let noteData = document.data()
            try await Firestore.firestore().collection("users").document(currentUserId).collection("feed").document(document.documentID).setData(noteData)
        }
    }
    func updateUserFeedAfterRemovingFriend(removedFriendUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Remove User 2's posts from current user's feed
        try await removeFriendPostsFromFeed(currentUserId: currentUid, friendId: removedFriendUid)
        
        // Fetch User 2's first-degree UserService.friends
        let firstDegreeFriends = await fetchFirstDegreeFriends(forUserID: removedFriendUid)
        
        // Remove posts of User 2's friends from current user's feed
        for friendId in firstDegreeFriends {
            try await removeFriendPostsFromFeed(currentUserId: currentUid, friendId: friendId)
        }
    }
    
    func removeFriendPostsFromFeed(currentUserId: String, friendId: String) async throws {
        let userFeedCollection = Firestore.firestore().collection("users").document(currentUserId).collection("feed")
        let notesSnapshot = try await userFeedCollection.whereField("ownerUid", isEqualTo: friendId).getDocuments()
        
        for document in notesSnapshot.documents {
            try await document.reference.delete()
        }
//        func checkIfUserIsFriend(uid: String) async -> Bool {
//                guard let currentUid = Auth.auth().currentUser?.uid else { return false }
//                let collection = FirestoreConstants.FriendsCollection.document(currentUid).collection("user-friends")
//                guard let snapshot = try? await collection.document(uid).getDocument() else { return false }
//                return snapshot.exists
//            }

//        func checkIfUserIsFriend(_ user: User) async -> Bool {
//                guard let currentUid = Auth.auth().currentUser?.uid else { return false }
//                let collection = FirestoreConstants.FriendsCollection.document(currentUid).collection("user-friends")
//                guard let snapshot = try? await collection.document(user.id).getDocument() else { return false }
//                return snapshot.exists
//            }
    }
    
    //    static func fetchSecondDegreeFriends(forUserID userID: String) async throws -> Set<String> {
    //        var secondDegreeFriends = Set<String>()
    //        let firstDegreeFriends = try await fetchFirstDegreeFriends(forUserID: userID)
    //
    //        try await withThrowingTaskGroup(of: Result<Set<String>, Error>.self) { group in
    //            for friendID in firstDegreeFriends {
    //                group.addTask {
    //                    do {
    //                        let friends = try await fetchFirstDegreeFriends(forUserID: friendID)
    //                        return .success(friends)
    //                    } catch {
    //                        return .failure(error)
    //                    }
    //                }
    //            }
    //
    //            for try await result in group {
    //                switch result {
    //                case .success(let friendSet):
    //                    secondDegreeFriends.formUnion(friendSet)
    //                case .failure(let error):
    //                    // Handle or propagate the error
    //                    throw error
    //                }
    //            }
    //        }
    //
    //        secondDegreeFriends.subtract(firstDegreeFriends)
    //        return secondDegreeFriends
    //    }
    
    static func fetchUserStats(uid: String) async throws -> UserStats {
        do {
            let friendsCount = try await UserService.shared.fetchFirstDegreeFriends(forUserID: uid).count
            let friendNetworkCount = try await fetchSecondDegreeFriends(forUserID: uid).count
            let notesSnapshot = try await FirestoreConstants.NotesCollection.whereField("ownerUid", isEqualTo: uid).getDocuments()
            let notesCount = notesSnapshot.count
            
            return .init(friendsCount: friendsCount, friendNetworkCount: friendNetworkCount, notesCount: notesCount)
        } catch {
            // Propagate the error
            throw error
        }
    }
}

extension UserService {
    private static func fetchUsers(_ snapshot: QuerySnapshot?) async throws -> [User] {
        var users = [User]()
        guard let documents = snapshot?.documents else { return [] }
        
        for doc in documents {
            let user = try await UserService.fetchUser(withUid: doc.documentID)
            users.append(user)
        }
        
        return users
    }
}
