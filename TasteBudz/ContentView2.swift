import SwiftUI

struct ContentView2: View {
    @State private var selection: Int = 0

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                SwipeView()
                    .tabItem {
                        Text("SwipeView 1")
                    }
                    .tag(0)

                SwipeView2()
                    .tabItem {
                        Text("SwipeView 2")
                    }
                    .tag(1)

                LoginView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(2)

//                SavedView()
//                    .tabItem {
//                        Image(systemName: "heart")
//                    }
//                    .tag(3)
//
//                MessagesView()
//                    .tabItem {
//                        Image(systemName: "message")
//                    }
//                    .tag(4)
//
//                ProfileView()
//                    .tabItem {
//                        Image(systemName: "person")
//                    }
//                    .tag(5)
            }
            .gesture(DragGesture().onEnded { gesture in
                if gesture.translation.width < 0 && self.selection < 5 {
                    self.selection += 1 // Swipe right to switch to the next tab
                } else if gesture.translation.width > 0 && self.selection > 0 {
                    self.selection -= 1 // Swipe left to switch to the previous tab
                }
            })
            .navigationBarTitle("Your App")
            .accentColor(.blue)

            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let topViewController = windowScene.windows.first?.rootViewController {
                        topViewController.view.isUserInteractionEnabled = true
                    }
                }            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView2()
//    }
//}

//#Preview {
//    ContentView2()
//}

