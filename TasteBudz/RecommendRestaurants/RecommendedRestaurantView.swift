//
//  RecommendRestaurantView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/30/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RecommendRestaurantView: View {
    @ObservedObject var restaurantFeedModel: RestaurantFeedModel

    @ObservedObject var viewModel = RecommendViewModel()
    @State private var searchTerm: String = ""
    
    var body: some View {
        //        NavigationView {
        //            List {
        //                ForEach(viewModel.businesses, id: \.id) { business in
        //                    Text(business.name ?? "no name")
        //                }
        //            }
        //            .listStyle(.plain)
        //            .navigationBarTitle(Text("Search for Restaurant"), displayMode: .large)
        //            .searchable(text: $viewModel.searchText) {
        //                            Text("")
        //                                .onTapGesture {
        //                                    viewModel.search()
        //                                }
        //                        }
        //            .onAppear(perform: viewModel.search)
        //        }
        
        VStack {
            Text("Recommend 2 Cheap Eats").font(.headline)
            Text("Start by searching").font(.caption)
            TextField("Search", text: $searchTerm, onEditingChanged: { _ in
                
            }, onCommit: {
                viewModel.search(searchTerm: $searchTerm.wrappedValue)
                print("search term: \(searchTerm)")
                
            }).textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            DisplayListofRestaurants(viewModel: viewModel)
            
            // Continue button
            Button(action: {
                // Handle the action when the continue button is tapped
                // You can check the selected restaurants in the `selectedRestaurants` set
                print("Continue button tapped with selected restaurants: \(viewModel.selectedRestaurants)")
                print(restaurantFeedModel.isInviteCodeEmpty)
                restaurantFeedModel.isInviteCodeEmpty = false;
                
                for item in viewModel.selectedRestaurants {
                    addRestaurantToFirebase(restID: item.id!, restName: item.name!)
                }
                
            }) {
                NavigationLink(destination: NotesTabView(restaurantFeedModel: restaurantFeedModel)) {
                    
                    Text("Done")
                        .foregroundColor(viewModel.selectedRestaurants.count >= 2 ? .white : .gray)
                        .padding(.vertical, 8) // Adjust the vertical padding to make the button shorter
                        .padding(.horizontal, 16)
                        .background(viewModel.selectedRestaurants.count >= 2 ? Color.blue : Color.gray.opacity(0.5))
                        .cornerRadius(8)
                }
                .padding()
                .disabled(viewModel.selectedRestaurants.count < 2)
                
            }.padding()
        }
        
        // added new function to change user to false once they've gotten past this screen
        //    func setNewUserFalse() {
        //        Task {
        //            let newUserData = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "tGl3BsN0vST8dqsO9FpIf4jrk7r2")
        //            try await newUserData.setData(["isNew": false], merge: true)
        //            // isNewState = false
        //
        //        }
        //    }
    }
}


func addRestaurantToFirebase(restID : String, restName : String){
    
    let db = Firestore.firestore()
    
    let restDoc = [
        "restName":restName,
        "userID":Auth.auth().currentUser?.uid.description,
        "restID":restID,
    ] as [String : Any]
    
    print(restDoc)
    
    //add new data point, no error will occur, no try catch is needed in this operation with no specific document
    db.collection("restaurants").addDocument(data: restDoc)
}

//#Preview {
//    RecommendRestaurantView()
//}

//struct RecommendRestaurantView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecommendRestaurantView(restaurantFeedModel: restaurantFeedModel)
//    }
//}
