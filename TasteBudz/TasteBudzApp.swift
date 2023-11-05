//
//  TasteBudzApp.swift
//  TasteBudz
//
//  Created by Litao Li on 10/31/23.
//

import SwiftUI
import Firebase

//@main
//struct TasteBudzApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

@main
struct TasteBudzApp: App {
    @StateObject var viewModel = AuthViewModel()
    init() {
        FirebaseApp.configure()
    }
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            InitialView()
                .environmentObject(viewModel)
        }
    }
}
