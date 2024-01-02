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
    @Published var userNetwork: Set<String> = []
    @Published var networkRestaurantKeys: Set<String> = []
    @Published var restInfoDict: [RestaurantInfo] = []
    @Published var restDictEmpty: Bool = true
    @Published var isInviteCodeEmpty = true
    
    
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


struct RestaurantInfo: Identifiable {
    let id = UUID()
    
    var name: String
    var type: String
    var address: String
    var rating: Double
    var hours: String
    var photos: [String]
    var imageURL: String
    var website: String
}
//
// i was testing out this func but needs some editing to get it to work

//extension RestaurantFeedModel {
//    // this is similar to the func of fetch notes used in the feed view model
//    func refreshRestaurantRecommendations() async {
//        // Clear existing data
//        self.restInfoDict.removeAll()
//        self.networkRestaurantKeys.removeAll()
//        self.userNetwork.removeAll()
//
//        // Re-fetch data
//        self.userNetwork = await populateNetwork(forUserID: Auth.auth().currentUser?.uid ?? "")
//        self.userNetwork.insert(Auth.auth().currentUser?.uid ?? "")
//
//        for user in self.userNetwork {
//            let restKey = await getRestaurantsFromUID(userid: user)
//            for restaurant in restKey {
//                self.networkRestaurantKeys.insert(restaurant)
//            }
//        }
//
//        for rKey in self.networkRestaurantKeys {
//            // Assuming you have a method to get restaurant details by ID
//            if let restaurantInfo = await getRestaurantInfo(byID: rKey) {
//                DispatchQueue.main.async {
//                    self.restInfoDict.append(restaurantInfo)
//                }
//            }
//        }
//    }
//// while the other func getUserRestaurantsFromUID() is only able to generate a list of restaurants associated with one user, this is for when you have a restaurant ID (which could be from any user's list) and you need to display or work with detailed information about that restaurant
//
//    private func getRestaurantInfo(byID id: String) async -> RestaurantInfo? {
//        let db = Firestore.firestore()
//
//        do {
//            let documentSnapshot = try await db.collection("restaurants").document(id).getDocument()
//            if let restaurantData = documentSnapshot.data() {
//                // Manually extract values and initialize RestaurantInfo
//                let name = restaurantData["name"] as? String ?? "N/A"
//                let type = restaurantData["type"] as? String ?? "N/A"
//                let address = restaurantData["address"] as? String ?? "N/A"
//                let rating = restaurantData["rating"] as? Double ?? 0.0
//                let hours = restaurantData["hours"] as? String ?? "N/A"
//                let photos = restaurantData["photos"] as? [String] ?? []
//                let imageURL = restaurantData["imageURL"] as? String ?? ""
//                let website = restaurantData["website"] as? String ?? ""
//
//                return RestaurantInfo(name: name, type: type, address: address, rating: rating, hours: hours, photos: photos, imageURL: imageURL, website: website)
//            }
//        } catch {
//            print("Error fetching restaurant details: \(error)")
//        }
//
//        return nil
//    }
//}

