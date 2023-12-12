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
                
                for item in viewModel.selectedRestaurants {
                    addRestaurantToFirebase(restID: item.id!, restName: item.name!)
                }
                
            }) {
                Text("Continue")
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

struct RecommendRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendRestaurantView()
    }
}
