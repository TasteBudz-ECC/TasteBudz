//
//  TasteBudzApp.swift
//  TasteBudz
//
//  Created by Litao Li on 10/31/23.
//

import SwiftUI

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
    @ObservedObject var restaurantFeedModel = RestaurantFeedModel()
    @ObservedObject var signUpModel = SignUpModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentViewOfficial(restaurantFeedModel: restaurantFeedModel)
//            RequestUserContactsView()
//            InviteCodePopUpView()
        }
    }
}
