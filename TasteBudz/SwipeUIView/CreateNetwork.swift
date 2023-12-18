//
//  CreateNetwork.swift
//  TasteBudz
//
//  Created by Litao Li on 12/8/23.
//

//import Foundation
//import FirebaseFirestore
//import Firebase
//
//
//// Returns an array of the user's network
//func populateNetwork(forUserID currentUserID: String) async -> [String] {
//    var firstDegreeNetwork: [String] = []
//    var network: [String] = []
//    
//    // Find user's first degree connection
//    func fetchFriends(forUserID userID: String) async {
//        let db = Firestore.firestore()
//        let friendsCollection = db.collection("friends")
//        
//        do {
//            let friendsQuery = friendsCollection.whereField("primary", isEqualTo: userID)
//            let friendsSnapshot = try await friendsQuery.getDocuments()
//            
//            for document in friendsSnapshot.documents {
//                if let friendID = document["secondary"] as? String {
//                    print("friendID: \(friendID)")
//                    if currentUserID == userID {
//                        firstDegreeNetwork.append(friendID)
//                        
//                    }
//                    network.append(friendID)
//                }
//            }
//        } catch {
//            print("Error fetching friends: \(error.localizedDescription)")
//        }
//    }
//    print("firstDegree: \(firstDegreeNetwork)")
//    // Start the recursive friend fetching for the initial user
//    await fetchFriends(forUserID: currentUserID)
//    
//    
//    // Find second degree connection
//    for item in firstDegreeNetwork {
//        await fetchFriends(forUserID: item)
//    }
//    
//    print("network \(network)")
//    return network
//}
