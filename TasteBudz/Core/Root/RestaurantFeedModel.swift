//
//  RestaurantFeedModel.swift
//  TasteBudz
//
//  Created by Jessica C on 12/16/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class RestaurantFeedModel: ObservableObject {
    @Published var userNetwork: [String] = []
    @Published var networkRestaurantKeys: Set<String> = []
    @Published var restInfoDict: [String: (name: String, type: String, photos: [String], address: String, rating: Double, hours: String, imageURL: String)] = [:]
    @Published var restDictEmpty: Bool = true
    
    
//// set up the userNetwork array to contain the user logged in and their mutuals
//    userNetwork = await populateNetwork(forUserID: Auth.auth().currentUser?.uid ?? "tGl3BsN0vST8dqsO9FpIf4jrk7r2")
//    userNetwork.append(Auth.auth().currentUser?.uid ?? "tGl3BsN0vST8dqsO9FpIf4jrk7r2")
//    
//// check for duplicates in the array of restaurants
//    for user in userNetwork {
//        let restKey = await getRestaurantsFromUID(userid: user) // creates an array of restaurants
//
//        for restaurant in restKey {
//            networkRestaurantKeys.insert(restaurant) // inserts into the set, doesn't insert dups
//        }
//    }
////                  // goes through all of the restaurant keys of the network and gets their imageURLs and names
//                    // replace this later with new function
//                    
//        for rKey in Set(networkRestaurantKeys) {
//            restDetailRetrieval(businessID: rKey, toRetrieve: "image_url") { rKeyImageURL in
//                restDetailRetrieval(businessID: rKey, toRetrieve: "name") { rKeyName in
////                              print(rKeyImageURL!, rKeyName!)
//                    restInfoDict[rKey] = (imageURL: rKeyImageURL ?? "", name: rKeyName ?? "")
//                }
//            }
//        }
//
}


