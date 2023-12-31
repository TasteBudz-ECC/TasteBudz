//
//  NotesTabView.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI

struct NotesTabView: View {
    
    @ObservedObject var restaurantFeedModel: RestaurantFeedModel
    @State private var selectedTab = 0
    
    var body: some View {
            TabView(selection: $selectedTab) {
                FeedView(restaurantFeedModel: restaurantFeedModel)
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                    }
                    .onAppear { selectedTab = 0 }
                    .tag(0)
                
                ExploreView()
                    .tabItem { Image(systemName: "magnifyingglass") }
                    .onAppear { selectedTab = 1 }
                    .tag(1)
                
                CreateNoteDummyView(tabIndex: $selectedTab)
                    .tabItem { Image(systemName: "plus") }
                    .onAppear { selectedTab = 2 }
                    .tag(2)
                
                ActivityView()
                    .tabItem {
                        Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                            .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                    }
                    .onAppear { selectedTab = 3 }
                    .tag(3)
                
                CurrentUserProfileView()
                    .tabItem {
                        Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                            .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                    }
                    .onAppear { selectedTab = 4 }
                    .tag(4)
            }
            .tint(Color(red:205/255, green:125/255, blue:245/255))

    }
}

//struct NotesTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotesTabView()
//    }
//}
