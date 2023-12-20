//
//  UserListView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

//import SwiftUI

import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel: ExploreViewModel
    @State private var searchText = ""
    
    var users: [User] {
        return searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(users) { user in
                    NavigationLink(value: user) {
                        UserCell(user: user)
                            .padding(.leading)
                    }
                }
                
            }
            .navigationBarItems(trailing:
                            NavigationLink(destination: RequestUserContactsView()) {
                                HStack {
//                                    navigationTitle("Search")
//                                    Text("Search").font(.title)
//                                        .padding(.leading)
                                    Spacer()
                                    Image(systemName: "person.badge.plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(Color(red:205/255, green:125/255, blue:245/255))
                                        .padding()
                                }
                            }
                        )
                        .padding(.top)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(viewModel: ExploreViewModel())
    }
}
