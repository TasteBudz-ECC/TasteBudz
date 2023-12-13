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
    @State var userRestaurantKeys: [String] = []
    @State var imageLinks: [String] = []
    
    
    var imageURL = URL(string:"https://images.prismic.io/bar-louie%2F28acb893-a2eb-4542-b063-d3c0cb3eb94c_739143_495794_1518558828478.jpg")
    
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
                
                
                // pull the image links from yelp api using the keys
//                 let restaurantImageLinks = getImageURLsForRestaurants(restaurantKeys: userRestaurantKeys, completion: <#T##([String?]) -> Void#>)
              
                
                // View of restaurants
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 20){
                        
//                        for link in restaurantImageLinks {
//                        print("vstack \(imageLinks)")
                        ForEach(imageLinks, id: \.self) { link in
                            VStack {
                                //                                Text("link \(link)")
                                //AsyncImage(url: imageURL) { image in image
                                
                                AsyncImage(url: URL(string: link)) {image in image
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:150, height: 200)
                                    .cornerRadius(20)
                                //
                                    
                                } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    Text("Bar Louie") // insert restaurant name
                                    
                                
                            }
                        }
                        
                        ForEach(2..<10) {
                            Text("Restaurant \($0)")
                                .foregroundStyle(.white)
                                .font(.headline)
                                .frame(width: 150, height: 200)
                                .border(Color.gray, width:2)
                                .cornerRadius(20)
                                .background(.purple)
                            
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
                    userRestaurantKeys = await getRestaurantsFromUID(userid: "3Xi8IpFv9Df42WafUHjpaK5nSOd2")
//                    print("userRestaurant \(userRestaurantKeys)")
                    
//                    let restaurantImageLinks = try await getImageURLsForRestaurants(restaurantKeys: ["boE4Ahsssqic7o5wQLI04w"])
//                    print("restaurantImageLinks \(restaurantImageLinks)")
                    
                    
                    //  = ["http://s3-media4.fl.yelpcdn.com/bphoto/6He-NlZrAv2mDV-yg6jW3g/o.jpg"]
                    // imageLinks = ["https://images.prismic.io/bar-louie%2F28acb893-a2eb-4542-b063-d3c0cb3eb94c_739143_495794_1518558828478.jpg"]
                    
                    
                    
                    for rKey in userRestaurantKeys {
                        let restRetreive = try await restDetailRetrieval(businessID: rKey, toRetrieve: "image_url"){ data in
                            imageLinks.append(data!)
                        }
                    }
                    
                    print("imageLinks \(imageLinks)")

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


// DELETE THIS FUNCTION LATER
func getImageURLsForRestaurants(restaurantKeys: [String]) async throws -> [String] {
    let apiKey = "CBz-Ykj4Kpaw9hum4DDI9hIJcRg7Q0uvtbEeAe_znKmG-HF6av3NUdQBI1OZihgG0YILrSS6KOb1ZRsoCs_HSNc4KutlGnkOKAAYw7p_MRXvdgdn4EBtwMBsxc1VZXYx"
    let baseURL = "https://api.yelp.com/v3/businesses/"
    
    var imageURLs = [String]()
    
    for restaurantKey in restaurantKeys {
        do {
            let endpoint = baseURL + restaurantKey
            guard let url = URL(string: endpoint) else {
                imageURLs.append("")
                continue
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let business = try decoder.decode(Business.self, from: data)
            
            // Access the image URL from the decoded Business model
            if let imageURL = business.imageURL {
                imageURLs.append(imageURL)
            } else {
                print("not found")
                imageURLs.append("")
            }
        } catch {
            print("Error fetching image URL for restaurant \(restaurantKey): \(error)")
            throw error // Propagate the error
        }
    }
    
    return imageURLs
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
