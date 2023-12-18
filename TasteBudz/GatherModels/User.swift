//
//  User.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import FirebaseFirestoreSwift
import Firebase
import Foundation

struct User: Identifiable, Codable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
    var link: String?
    var stats: UserStats?
    
    // Flags to indicate relationship status with the current user
    var isFriends: Bool?
    var isInFriendNetwork: Bool?
    
//    var friends: [User]? // An array to hold the user's friends
//    var friendNetwork: [User]? // An array to hold the user's friend network
    var friendIds: [String]?
    var friendNetworkIds: [String]?
    
    @DocumentID var id: String?  // Using @DocumentID for automatic ID handling from Firestore
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Represents statistical data related to a user.
struct UserStats: Codable {
    var friendsCount: Int
    var friendNetworkCount: Int
    var notesCount: Int

    init(friendsCount: Int = 0, friendNetworkCount: Int = 0, notesCount: Int = 0) {
        self.friendsCount = friendsCount
        self.friendNetworkCount = friendNetworkCount
        self.notesCount = notesCount
    }
}

