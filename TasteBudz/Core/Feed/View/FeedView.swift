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

//   @State var imageLinks: [String] = []
    
   @State var networkRestaurantKeys: Set<String> = []
    @State var restInfoDict: [String: (imageURL: String, name: String)] = [:]
    
    
    var testImageURL = URL(string:"https://images.prismic.io/bar-louie%2F28acb893-a2eb-4542-b063-d3c0cb3eb94c_739143_495794_1518558828478.jpg")
    
    var body: some View {
        
//        ScrollView(){
        
            VStack{
                VStack(alignment: .leading) {
                                    Image("Gather_1024x1024_1")
                                        .resizable()
                                        .scaledToFill() // Use scaledToFill to fill the frame, cropping if needed
                                        .frame(width: 100, height: 50) // Adjust the size as needed
                                        .clipped()
                                }
                                
                                HStack{
                                    Text("      Scroll to Explore Restaurant Options      ")
                                        .font(.title)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                    
                                    
                                }

                
                
                // retrieve user's recommended restaurants (yelp keys)
                // retrieve user friends and mutuals recommended restaurants
                // store these all in the same array, check for duplicates
                
                
                /* get list of user's network, for each person in their network, get their restaurant keys and append them to userRestaurantKeys*/
            
                // pull the image links from yelp api using the keys

              
                
                // View of restaurants
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 20){
                        
                        Text("restaurants will be here").multilineTextAlignment(.center)
//                        ForEach(Array(restInfoDict.keys), id: \.self) { rest in
//                            VStack {
//                                let link = restInfoDict[rest]?.imageURL
//                                AsyncImage(url: URL(string: link ?? "https://static.vecteezy.com/system/resources/thumbnails/002/412/377/small/coffee-cup-logo-coffee-shop-icon-design-free-vector.jpg")) {image in image // change the default link to our logo
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
//                                Text(restInfoDict[rest]?.name ?? "not found")
//                                    .frame(maxWidth: 200)
//                                    // .frame(maxWidth: .infinity, alignment: .leading)
//                                    .fixedSize(horizontal: false, vertical: true)
//
//                            }
//                        }
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
                    
                    
                    // Auth.auth().currentUser!.uid, "tGl3BsN0vST8dqsO9FpIf4jrk7r2"
                    // "3Xi8IpFv9Df42WafUHjpaK5nSOd2"
                    
                    // set up the userNetwork array to contain the user logged in and their mutuals
                    userNetwork = await populateNetwork(forUserID: Auth.auth().currentUser?.uid ?? "tGl3BsN0vST8dqsO9FpIf4jrk7r2")
                    userNetwork.append(Auth.auth().currentUser?.uid ?? "tGl3BsN0vST8dqsO9FpIf4jrk7r2")
                    
                     print(userNetwork)

                    // check for duplicates in the array of restaurants
//                    for user in userNetwork {
//                        let restKey = await getRestaurantsFromUID(userid: user) // creates an array of restaurants
//                        
//                        for restaurant in restKey {
//                            networkRestaurantKeys.insert(restaurant) // inserts into the set, doesn't insert dups
//                        }
//                    }
//                    
                    
                    
//                  // goes through all of the restaurant keys of the network and gets their imageURLs and names
                    
//                    for rKey in Set(networkRestaurantKeys) {
//                        restDetailRetrieval(businessID: rKey, toRetrieve: "image_url") { rKeyImageURL in
//                            restDetailRetrieval(businessID: rKey, toRetrieve: "name") { rKeyName in
////                              print(rKeyImageURL!, rKeyName!)
//                                restInfoDict[rKey] = (imageURL: rKeyImageURL ?? "", name: rKeyName ?? "")
//                            }
//                        }
//                    }
                    
                    print("network rest keys: \(networkRestaurantKeys)")
                    print("restInfoDict: \(restInfoDict)")
                    

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
