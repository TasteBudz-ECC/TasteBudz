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

//// function to get restaurant yelp keys from the user's recommended 
//func getRestaurantFromUID(userid: String) async -> [String:Any]{
//    let fs = Firestore.firestore()
//    
//    let data = fs.collection("restaurants").whereField("userID", isEqualTo: userid)
//    
//    var restaurantArray = [String]()
//    
//    do {
//        let dataSnapshot = try await data.getDocuments()
//        
//        for dataItem in dataSnapshot.documents{
//            let dataPoint = dataItem.data()
//            
//            if let restaurantID = dataPoint["restaurantIDKey"] as? String {
//                            restaurantArray.append(restaurantID)
//                        }
//        }
//    } catch {
//        print("\(error) + An Error has occured retrieving data")
//    }
//    
//    return restaurantArray
//}


struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    
    
    var imageURL = URL(string:"https://images.prismic.io/bar-louie%2F28acb893-a2eb-4542-b063-d3c0cb3eb94c_739143_495794_1518558828478.jpg")
    
    var body: some View {
        
        ScrollView(){
            VStack{
                
                HStack{
                    Text("Explore Restaurant Options >>")
                        .font(.title)
                    
                }
                // retrieve user's recommended restaurants (yelp keys)
//                db.collection("restaurants").whereField("userID", isEqualTo: Auth.auth().currentUser?.uid.description).getDocuments() {
//                    (querySnapshot, err) in
//                        if let err = err {
//                          print("Error getting documents: \(err)")
//                        } else {
//                          for document in querySnapshot!.documents {
//                            print("\(document.documentID) => \(document.data())")
//                          }
//                    }
//                }
                
                
                // retrieve user friends and mutuals recommended restaurants
                // store these all in the same array, check for duplicates
                // pull the image links from yelp api using the keys
//
                
                // View of restaurants
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 20){
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
                            
                            Text("Bar Louie")
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
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                Task { try await viewModel.fetchNotes() }
                            } label: {
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(Color.theme.primaryText)
                            }
                            
                        }
                    }
                    .padding([.top, .horizontal])
                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
