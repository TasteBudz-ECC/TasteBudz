//
//  RegistrationView.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RegistrationView: View {
    @ObservedObject var restaurantFeedModel: RestaurantFeedModel
    
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var hasSignedUp = false
    @State private var presented = false // State to manage the presentation of RequestUserContactsView
    @State private var shouldNavigate = false // State to manage navigation
    
    //temp State variable for the friend code input
    @State private var inviteCode: String = ""

    var body: some View {
        VStack {
            Spacer()
                        
                        // logo image
                        Image("GatherIcon_1024x1024")
                            // .renderingMode(.template)
                            .resizable()
                            // .colorMultiply(Color.theme.primaryText)
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding()
                        
                        // text fields
                        VStack {
                            TextField("Enter your email", text: $viewModel.email)
                                .autocapitalization(.none)
                                .modifier(NotesTextFieldModifier())
                            
                            SecureField("Enter your password", text: $viewModel.password)
                                .modifier(NotesTextFieldModifier())
                            
                            TextField("Enter your full name", text: $viewModel.fullname)
                                .autocapitalization(.none)
                                .modifier(NotesTextFieldModifier())
                            
                            TextField("Enter your username", text: $viewModel.username)
                        .autocapitalization(.none)
                                .modifier(NotesTextFieldModifier())
                            
                            TextField("Invite Code (optional)", text: $inviteCode)
                                .autocapitalization(.none)
                                .modifier(NotesTextFieldModifier())
                            
                        }
//

            Button {
                Task {
                    try await signUpAndInviteContacts()
                    
                    // add add friend function here?
                    if inviteCode != "" {
                        await addFriendFromCode(friendCodeInput: inviteCode)
                    }
                    
                }
            } label: {
//                NavigationLink(destination: RequestUserContactsView(restaurantFeedModel: restaurantFeedModel)){
                    Text(viewModel.isAuthenticating ? "" : "Sign up")
                        .foregroundColor(Color.theme.primaryBackground)
                        .modifier(NotesButtonModifier())
                        .overlay {
                            if viewModel.isAuthenticating {
                                ProgressView()
                                    .tint(Color.theme.primaryBackground)
                            }
//                        }
                }
            }
            .disabled(viewModel.isAuthenticating || !formIsValid)
            .opacity(formIsValid ? 1 : 0.7)
            .padding(.vertical)

            Spacer()

            Divider()

            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color.theme.primaryText)
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.authError?.description ?? ""))
        }
        .background(
            Text("")
                .hidden()
                .navigationDestination(isPresented: $shouldNavigate) {
                    RequestUserContactsView()
                    Text("") // Optionally, use hidden text for better readability or as needed
                        .hidden()
                }
        )
        .onChange(of: shouldNavigate) { newValue in
            // Reset the navigation flag after navigation
            if newValue {
                shouldNavigate = false
            }
        }


//        .fullScreenCover(isPresented: $hasSignedUp) {
//            RequestUserContactsView()
//        }
//        .sheet(isPresented: $presented) {
//                    RequestUserContactsView()
//            }
    }

    // Function to sign up and initiate contacts invitation
    func signUpAndInviteContacts() async {
        do {
            // Sign up the user
            try await viewModel.createUser()
            hasSignedUp = true // Set flag to navigate to contacts invitation view
            shouldNavigate = true // Trigger navigation to RequestUserContactsView
        } catch {
            print("Error signing up: \(error.localizedDescription)")
            // Handle sign up error
        }
    }
    
    // Function to add user and their friend from code inputted
//    func addFriendFromCode(friendCodeInput: String) async {
//        let db = Firestore.firestore()
//        let friendsCollection = db.collection("friends")
//
//        do {
//            // search through the "users" collection to check their code fields
//            // if the code matches, then get that user's id
//            // add the current user to the friends collection as primary,
//            // add the other user to the friends collection as seconday
//            
//            let codeQuery = friendsCollection.whereField("friendCode", isEqualTo: friendCodeInput)
//            let friendCodeMatch = try await codeQuery.getDocuments() // gets the user
//            
//            let friendsDoc = [
//                "primary": Auth.auth().currentUser?.uid,
//                "secondary": "tGl3BsN0vST8dqsO9FpIf4jrk7r2"//friendCodeMatch.id
//            ]
//            
//            try await db.collection("friends").addDocument(data: friendsDoc as [String : Any])
//            
//        } catch {
//            print("This code does not exist: \(error.localizedDescription)")
//        }
//    }

        
    func addFriendFromCode(friendCodeInput: String) async  {
        // search through the "users" collection to check their code fields
        // if the code matches, then get that user's id
        // add the current user to the friends collection as primary,
        // add the other user to the friends collection as seconday
        
        do {
            let db = Firestore.firestore()
            let friendsCollection = db.collection("friends")
            
            let codeQuery = friendsCollection.whereField("friendCode", isEqualTo: friendCodeInput)
            let friendCodeMatch = try await codeQuery.getDocuments() // gets the user document
            
            guard let friendDocument = friendCodeMatch.documents.first else {
                        print("No user found with the provided friend code.")
                        return
                    }
            // Create a friendship document with the current user as "primary" and the matched user as "secondary"
            let friendsDoc: [String: Any] = [
                "primary": Auth.auth().currentUser?.uid ?? "", // Using nil coalescing operator to handle optional
                "secondary": friendDocument.documentID
            ]
            
            try await db.collection("friends").addDocument(data: friendsDoc as [String : Any])
        } catch {
            
            print("This code does not exist: \(error.localizedDescription)")
        }
    }
            
            
        
    
    
    
    /* added here just for reference while creating new func
     func addRestaurantToFirebase(restID : String, restName : String){
         
         let db = Firestore.firestore()
         
         let restDoc = [
             "restName":restName,
             "userID":Auth.auth().currentUser?.uid.description,
             "restID":restID,
         ] as [String : Any]
         
         print(restDoc)
         
         //add new data point, no error will occur, no try catch is needed in this operation with no specific document
         db.collection("restaurants").addDocument(data: restDoc)
     }*/
    
    // MARK: - Form Validation

    var formIsValid: Bool {
        return !viewModel.email.isEmpty
            && viewModel.email.contains("@")
            && !viewModel.password.isEmpty
            && !viewModel.fullname.isEmpty
            && viewModel.password.count > 5
    }
}

//struct RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationView(restaurantFeedModel: restaurantFeedModel)
//    }
//}
