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
    
    
    
    var imageURL = URL(string:"https://images.prismic.io/bar-louie%2F28acb893-a2eb-4542-b063-d3c0cb3eb94c_739143_495794_1518558828478.jpg")
    
    var body: some View {
        
//        ScrollView(){
            VStack{
                
                HStack{
                    Text("Explore Restaurant Options >>")
                        .font(.title)
                    
                }
                
                
                // retrieve user's recommended restaurants (yelp keys)
                // let userRestaurantKeys = getRestaurantsFromUID(userid: Auth.auth().currentUser??.uid)
                
                // retrieve user friends and mutuals recommended restaurants
                // store these all in the same array, check for duplicates
                
                
                // pull the image links from yelp api using the keys
                // let restaurantImageLinks = getImageURLsForRestaurants(restaurantKeys: userRestaurantKeys, completion: <#T##([String?]) -> Void#>)
              
                
                // View of restaurants
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 20){
                        // for restaurant in restaurant array: get the imageurl of each of the restaurants
                        
//                        for link in restaurantImageLinks {
                            VStack {
                                AsyncImage(url: imageURL) { image in image
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:150, height: 200)
                                    //                                    .border(Color.gray, width:5)
                                        .cornerRadius(20)
                                    //
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                Text("Bar Louie") // insert restaurant name
                            }
//                        }
                        
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
            }
        //}
        //
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
            
            if let restaurantID = dataPoint["restaurantIDKey"] as? String {
                            restaurantArray.append(restaurantID)
                        }
        }
    } catch {
        print("\(error) + An Error has occured retrieving data")
    }
    
    return restaurantArray
}

func getImageURLsForRestaurants(restaurantKeys: [String], completion: @escaping ([String?]) -> Void) {
    let apiKey = "CBz-Ykj4Kpaw9hum4DDI9hIJcRg7Q0uvtbEeAe_znKmG-HF6av3NUdQBI1OZihgG0YILrSS6KOb1ZRsoCs_HSNc4KutlGnkOKAAYw7p_MRXvdgdn4EBtwMBsxc1VZXYx"
    let baseURL = "https://api.yelp.com/v3/businesses/"
    
    let group = DispatchGroup()
    var imageURLs = [String?]()
    
    for restaurantKey in restaurantKeys {
        group.enter()
        
        let endpoint = baseURL + restaurantKey
        guard let url = URL(string: endpoint) else {
            imageURLs.append(nil)
            group.leave()
            continue
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer {
                group.leave()
            }
            
            guard let data = data, error == nil else {
                imageURLs.append(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Assuming the image URL is nested inside the "image_url" key, adjust as needed
                if let imageURL = json?["image_url"] as? String {
                    imageURLs.append(imageURL)
                } else {
                    imageURLs.append(nil)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                imageURLs.append(nil)
            }
        }
        
        task.resume()
    }
    
    group.notify(queue: DispatchQueue.main) {
        completion(imageURLs)
    }
    
}


// example of how api is used
//func search(searchTerm: String) {
//    YelpApiService.live.search(searchTerm, "Chicago")
//        .sink { [weak self] businesses in
//            self?.businesses = businesses
//        }
//        .store(in: &cancellables)
//
//    print("Search Text: \(searchTerm)")
//}


//func get imageFromRestKey(restKey: String) async -> [String: Any] {
//    let imageArray = [restKey]
//
//    return imageArray
//}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
