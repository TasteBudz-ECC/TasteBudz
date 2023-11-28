//
//  ContentView.swift
//  TasteBudz
//
//  Created by Litao Li on 10/31/23.
//

import SwiftUI
import FirebaseFirestore
    

struct ContentView: View {
    @State private var selection: Int = 0
    var body: some View {
        TabView(selection: $selection) {
                    SwipeView()
                        .tabItem {
//                            Text("SwipeView 1")
                        }
                        .tag(0)

                    SwipeView2()
                        .tabItem {
//                            Text("SwipeView 2")
                        }
                        .tag(1)
                }
                .gesture(DragGesture().onEnded { gesture in
                    if gesture.translation.width < 0 && self.selection < 1 {
                        self.selection += 1 // Swipe right to switch to the next tab
                    } else if gesture.translation.width > 0 && self.selection > 0 {
                        self.selection -= 1 // Swipe left to switch to the previous tab
                    }
                })




//        VStack {
//            SignupLoginView()
//        }
//        .padding()


        /*
        TabView{

        /* Todo:
            Uncomment the views and change the name accordingly when the files have been created
         */
            // HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            // SavedView()
                .tabItem {
                    Image(systemName: "heart")
                }
            // MessagesView()
                .tabItem {
                    Image(systemName: "messages")
                }
            // ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .accentColor(.blue)

         */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


