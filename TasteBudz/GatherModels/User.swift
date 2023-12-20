//
//  User.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import FirebaseFirestoreSwift
import Firebase
import Foundation

struct User: Identifiable, Codable {
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
    var link: String?
    var stats: UserStats?
//    var isFollowed: Bool? old code
    // new code
    var isFriends: Bool?
    var isInFriendNetwork: Bool?
    // to here
    let id: String
    
    var isCurrentUser: Bool {
        return id == Auth.auth().currentUser?.uid
    }
}

struct UserStats: Codable {
// old code: 
//    var followersCount: Int
//    var followingCount: Int
    // new code:
    var friendsCount: Int
    var friendNetworkCount: Int
    // to here
    var notesCount: Int
}

extension User: Hashable {
    var identifier: String { return id }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
