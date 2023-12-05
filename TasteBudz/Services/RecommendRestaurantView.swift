//
//  RecommendRestaurantView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/30/23.
//

import SwiftUI

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
            Text("Recommond 2 restaurants").font(.headline)
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
            }) {
                Text("Continue")
                    .foregroundColor(viewModel.selectedRestaurants.count == 2 ? .white : .gray)
                    .padding()
                    .background(viewModel.selectedRestaurants.count == 2 ? Color.blue : Color.gray.opacity(0.5))
                    .cornerRadius(8)
            }
            .padding()
            .disabled(viewModel.selectedRestaurants.count != 2)
            
        }.padding()
    }
}

#Preview {
    RecommendRestaurantView()
}
