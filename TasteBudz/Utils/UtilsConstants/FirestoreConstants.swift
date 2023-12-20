//
//  FirestoreConstants.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Firebase

struct FirestoreConstants {
    private static let Root = Firestore.firestore()
    
    static let UserCollection = Root.collection("users")
    
    static let NotesCollection = Root.collection("notes")
    
//    static let FollowersCollection = Root.collection("followers")
//    static let FollowingCollection = Root.collection("following")

    static let RepliesCollection = Root.collection("replies")
    
    static let ActivityCollection = Root.collection("activity")
    
    static let FriendsCollection = Root.collection("friends")
}
