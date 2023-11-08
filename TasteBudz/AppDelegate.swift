//
//  AppDelegate.swift
//  TasteBudz
//
//  Created by Litao Li on 10/31/23.
//

import SwiftUI
import FirebaseCore

/*
 A Delegate controlls parts of the apps flow and its background interactions
 In this case when the app is launched and being used the first thing that happens is that
 Firebase is configured.
 
 This controlls the app on a per launch level. You can also use Scene Delegates to controll what happens per scene.
 */

//hi lol

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

//@main
//struct YourApp: App {
//  // register app delegate for Firebase setup
//  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//
//
//  var body: some Scene {
//    WindowGroup {
//      NavigationView {
//        ContentView()
//      }
//    }
//  }
//}
