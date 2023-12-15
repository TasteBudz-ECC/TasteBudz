//
//  ContentViewOfficial.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ContentViewOfficial: View {
    @StateObject var viewModel = ContentViewOfficialModel()
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else {
                NotesTabView()
            }
        }
        //            Task {
        //                let newUserData = try await Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "tGl3BsN0vST8dqsO9FpIf4jrk7r2").getDocument().data()
        //                let isNewUser = newUserData?["isNew"]
        //                isNew = (isNewUser != nil)
        //            }
        
    }
}


//func setNewUserFalse() {
//    Task {
//        let newUserData = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "tGl3BsN0vST8dqsO9FpIf4jrk7r2")
//        try await newUserData.setData(["isNew": false], merge: true)
//        
//    }
//}

struct ContentViewOfficial_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewOfficial()
    }
}
