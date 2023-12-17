//
//  InviteCodePopUpView.swift
//  TasteBudz
//
//  Created by Litao Li on 12/17/23.
//

import SwiftUI

//struct InviteCodePopUpView: View {
//    @ObservedObject var restaurantFeedModel: RestaurantFeedModel
//
//    
//    var body: some View {
//        NavigationView{
//            VStack {
//                Text("Please click this button to build your network and recommend cheap eats!")
//                    .font(.headline)
//                    .foregroundColor(.red)
//                    .padding()
//                    .multilineTextAlignment(.center)
//                
//                Button(action: {
//                    print("User Completing Invite and Recommendation")
//                }) {
//                    NavigationLink(destination: RequestUserContactsView(restaurantFeedModel:restaurantFeedModel)) {
//                        Text("Next")
//                            .foregroundColor(.blue)
//                            .padding()
//                    }
//                }
//                //                
//                //                Button(action: {
//                //                    print("User Completing Invite and Recommendation")
//                //                }) {
//                //                    Text("Next")
//                //                        .foregroundColor(.blue)
//                //                        .padding()
//                //                }
//                //                .background(NavigationLink(destination: RequestUserContactsView()) {
//                //                    EmptyView()
//                //                })
//                
//                
//                Spacer()
//            }
//        }
//    }
//}


struct InviteCodePopUpView: View {
    @ObservedObject var restaurantFeedModel: RestaurantFeedModel
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
//            Text("Please click this button to build your network and recommend cheap eats!")
//                .font(.headline)
//                .foregroundColor(.red)
//                .padding()
//                .multilineTextAlignment(.center)
            
            Button(action: {
                print("User Completing Invite and Recommendation")
                isSheetPresented = true
            }) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
            }
            .sheet(isPresented: $isSheetPresented) {
                RequestUserContactsView(restaurantFeedModel: restaurantFeedModel)
            }
            
            Spacer()
        }
        .padding()
    }
}
//#Preview {
//    InviteCodePopUpView()
//}
