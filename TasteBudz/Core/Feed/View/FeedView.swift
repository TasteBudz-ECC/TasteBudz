//
//  FeedView.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State var userNetwork: [String] = []
    @State var networkRestaurantKeys: [String] = []
//    @State var imageLinks: [String] = []
    @State var restInfoDict: [String: (imageURL: String, name: String)] = [:]
    
    
    var testImageURL = URL(string:"https://images.prismic.io/bar-louie%2F28acb893-a2eb-4542-b063-d3c0cb3eb94c_739143_495794_1518558828478.jpg")
    
    var body: some View {
        
//        ScrollView(){
            VStack{
                
                HStack{
                    Text("Explore Restaurant Options >>")
                        .font(.title)
                    
                }
                
                
                // retrieve user's recommended restaurants (yelp keys)
//                 let userRestaurantKeys = getRestaurantsFromUID(userid: Auth.auth().currentUser??.uid)
                
                // retrieve user friends and mutuals recommended restaurants
                // store these all in the same array, check for duplicates
                
                
                /* get list of user's network, for each person in their network, get their restaurant keys and append them to userRestaurantKeys*/
                
                
                // pull the image links from yelp api using the keys
//                 let restaurantImageLinks = getImageURLsForRestaurants(restaurantKeys: userRestaurantKeys, completion: <#T##([String?]) -> Void#>)
              
                
                // View of restaurants
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 20){
                        
//                        ForEach(imageLinks, id: \.self) { link in
//                            VStack {
//                                //                                Text("link \(link)")
//                                //AsyncImage(url: imageURL) { image in image
//                                
//                                AsyncImage(url: URL(string: link)) {image in image
//                                    .resizable()
//                                    .scaledToFit()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width:150, height: 200)
//                                    .cornerRadius(20)
//                                //
//                                    
//                                } placeholder: {
//                                        ProgressView()
//                                    }
//                                    
//                                    Text("Bar Louie") // insert restaurant name
//                                    
//                                
//                            }
//                        }
                        
                        ForEach(Array(restInfoDict.keys), id: \.self) { rest in
                            VStack {
                                let link = restInfoDict[rest]?.imageURL
                                AsyncImage(url: URL(string: link ?? "https://static.vecteezy.com/system/resources/thumbnails/002/412/377/small/coffee-cup-logo-coffee-shop-icon-design-free-vector.jpg")) {image in image // change the default link to our logo
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:150, height: 200)
                                    .cornerRadius(20)
                                //

                                } placeholder: {
                                        ProgressView()
                                    }

                                Text(restInfoDict[rest]?.name ?? "not found")
                                    .frame(maxWidth: 200)
                                    // .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)

                            }
                        }
                        
                    }
                }
                
                // if no post yet, then have text that says "be the first post!"
                
                
                // list of all posts
                NavigationStack {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.notes) { note in
                                NavigationLink(value: note) {
                                    NoteCell(config: .note(note))
                                }
                            }
                            .padding(.top)
                        }
                    }
                    .refreshable {
                        Task { try await viewModel.fetchNotes() }
                    }
                    .overlay {
                        if viewModel.isLoading { ProgressView() }
                    }
                    .navigationDestination(for: User.self, destination: { user in
                        if user.isCurrentUser {
                            CurrentUserProfileView(didNavigate: true)
                        } else {
                            ProfileView(user: user)
                        }
                    })
                    .navigationDestination(for: Note.self, destination: { note in
                        NoteDetailsView(note: note)
                    })
                    .navigationTitle("Notes")
                    .navigationBarTitleDisplayMode(.inline)
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            Button {
//                                Task { try await viewModel.fetchNotes() }
//                            } label: {
//                                Image(systemName: "arrow.counterclockwise")
//                                    .foregroundColor(Color.theme.primaryText)
//                            }
//                            
//                        }
//                    }
//                    .padding([.top, .horizontal])
                }
            // NEW EDITS
            }.onAppear {
                Task {
                    
                    
                    // Auth.auth().currentUser!.uid
                    // "3Xi8IpFv9Df42WafUHjpaK5nSOd2"
                    
                    // set up the userNetwork array to contain the user logged in and their mutuals
                    userNetwork = await populateNetwork(forUserID: "tGl3BsN0vST8dqsO9FpIf4jrk7r2")
                    userNetwork.append("tGl3BsN0vST8dqsO9FpIf4jrk7r2")
                    
                    // print(userNetwork)

                    for user in userNetwork {
                        let restKey = await getRestaurantsFromUID(userid: user)
                        networkRestaurantKeys.append(contentsOf: restKey)
                    }
//                    
//                     UNCOMMENT THIS CODE TO TEST HARD-CODED FIREBASE DATA
//                     networkRestaurantKeys = await getRestaurantsFromUID(userid: "tGl3BsN0vST8dqsO9FpIf4jrk7r2")
                    
                    // ADD THIS BACK IN IF NEEDED (generates array of images, doesn't use the restaurant dictionary)
//                    for rKey in userRestaurantKeys {
//                        let _: () = restDetailRetrieval(businessID: rKey, toRetrieve: "image_url"){ data in
//                            imageLinks.append(data!)
//                        }
//                    }
                    
//                  // goes through all of the restaurant keys of the network and gets their imageURLs and names
                    for rKey in networkRestaurantKeys {
                        restDetailRetrieval(businessID: rKey, toRetrieve: "image_url") { rKeyImageURL in
                            restDetailRetrieval(businessID: rKey, toRetrieve: "name") { rKeyName in
                                restInfoDict[rKey] = (imageURL: rKeyImageURL ?? "", name: rKeyName ?? "")
                            }
                        }
                    }
                    

                }

            }
    }
}

//// function to get restaurant yelp keys from the user's recommended
func getRestaurantsFromUID(userid: String) async -> [String]{
    let fs = Firestore.firestore()
    
    let data = fs.collection("restaurants").whereField("userID", isEqualTo: userid)
    
    var restaurantArray = [String]()
    
    do {
        let dataSnapshot = try await data.getDocuments()
        
        for dataItem in dataSnapshot.documents{
            let dataPoint = dataItem.data()
            
            if let restaurantID = dataPoint["restID"] as? String {
                            restaurantArray.append(restaurantID)
                        }
        }
    } catch {
        print("\(error) + An Error has occured retrieving data")
    }
    
    return restaurantArray
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
