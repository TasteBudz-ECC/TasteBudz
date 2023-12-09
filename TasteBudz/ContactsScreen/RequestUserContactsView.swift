//
//  RequestUserContactsView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/15/23.
//

import SwiftUI
import Contacts
import FirebaseFirestore
import FirebaseAuth

struct RequestUserContactsView: View {
    @State private var contacts = [ContactModel]()
    @State private var selectedContact: ContactModel?
    @State private var selectedNumber: String?
    @State private var invitedFriendsCount: Int = 0 // Keep track of the invited friends count
    @State private var isNavigationActive: Bool = false
    
    
    
    var body: some View {
        VStack{
            Text("Set up your")
            Text("friends")
                .font(.title2)
                .bold()
            Text("Invite 3 friends")
                .foregroundColor(Color(UIColor(hex: 0x000000)))
            //                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(UIColor(hex: 0xf7b2ca)).opacity(0.5))
                .cornerRadius(8)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
            
            ScrollView {
                VStack {
                    // Displays each contact
                    ForEach(contacts) { contact in
                        HStack {
                            Text(contact.fullName)
                            Spacer()
                            
                            // When button is clicked, an invite it sent
                            Button(action: {
                                var randCode = ""
                                repeat {
                                    randCode = generateRandomCode()
                                } while codeExistsInFirestore(randCode)
                                addPendingInviteCodes(randCode: randCode)
                                contact.sendInvite(randCode: randCode)
                                invitedFriendsCount += 1
                            }) {
                                Text("Invite")
                                    .foregroundColor(Color(UIColor(hex: 0x000000)))
                                //                            .foregroundColor(.blue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(UIColor(hex: 0xf7b2ca)).opacity(0.5))
                                    .cornerRadius(8)
                                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                        }
                        .padding()
                    }
                    
                }
                .onAppear {
                    Task.init {
                        await fetchAllContacts()
                    }
                    
                }
            }
            
            Text("Invited Friends: \(invitedFriendsCount)")
                .foregroundColor(.gray)
                .padding(.bottom, 16)
            
            //            Button(action: {
            //                // Handle the action when the continue button is tapped
            //                if invitedFriendsCount >= 3 {
            //                    // Proceed with the app flow
            //                    print("Continue button tapped with at least 3 invited friends")
            //                    // Move on to the recommend restaurant page
            //                } else {
            //                    // Display an alert or message indicating the user to invite at least 3 friends
            //                    print("Invite at least 3 friends to proceed")
            //                }
            //            }) {
            //                Text("Continue")
            //                    .foregroundColor(invitedFriendsCount >= 3 ? .white : .gray)
            //                    .padding(.vertical, 8) // Adjust the vertical padding to make the button shorter
            //                    .padding(.horizontal, 16)
            //                    .background(invitedFriendsCount >= 3 ? Color.blue : Color.gray.opacity(0.5))
            //                    .cornerRadius(8)
            //            }
            //            .padding()
            //            .disabled(invitedFriendsCount < 3)
            NavigationLink(destination: RecommendRestaurantView(), isActive: $isNavigationActive) {
                EmptyView()
            }
            
            Button(action: {
                // Handle the action when the continue button is tapped
                if invitedFriendsCount >= 3 {
                    // Proceed with the app flow
                    print("Continue button tapped with at least 3 invited friends")
                    isNavigationActive = true // Activate navigation to RecommendRestaurantView
                } else {
                    // Display an alert or message indicating the user to invite at least 3 friends
                    print("Invite at least 3 friends to proceed")
                }
            }) {
                Text("Continue")
                    .foregroundColor(invitedFriendsCount >= 3 ? .white : .gray)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(invitedFriendsCount >= 3 ? Color.blue : Color.gray.opacity(0.5))
                    .cornerRadius(8)
            }
            .padding()
            .disabled(invitedFriendsCount < 3)
            
        }
    }
    
    func fetchAllContacts() async {
        var fetchedContacts: [ContactModel] = []
        
        // Fun this in the background async (Maybe right after user clicks sign up button)
        
        // Get access to the Contacts store
        let store = CNContactStore()
        
        // Specify which data keys we want to fetch: Name and Phone Number
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor] // "as" is used to cast the array of strings as a CNKeyDescriptor
        
        // Create fetch request
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        // Call method to fetch all contacts
        do {
            try store.enumerateContacts(with: fetchRequest) { contact, result in
                let fullName = "\(contact.givenName) \(contact.familyName)"
                let phoneNumbers = contact.phoneNumbers.map { phoneNumber in
                    switch phoneNumber.label {
                    case CNLabelPhoneNumberMobile:
                        return ContactPhoneNumber(type: .mobile, number: phoneNumber.value.stringValue)
                    case CNLabelPhoneNumberMain:
                        return ContactPhoneNumber(type: .main, number: phoneNumber.value.stringValue)
                    default:
                        return ContactPhoneNumber(type: .other, number: phoneNumber.value.stringValue)
                    }
                }
                
                let newContact = ContactModel(fullName: fullName, phoneNumbers: phoneNumbers)
                fetchedContacts.append(newContact)
                
                // Do something: Write code to send an invite to user's contacts
                
                // Step 1: When button is pressed
                
                // Step 2: Auto-generates a message
                
                // Step 3: Sends invite to contact
                
                // For now, we just print
                print(contact.givenName, contact.familyName)
                //                print(contact.familyName)
                for number in contact.phoneNumbers {
                    
                    switch number.label {
                        
                    case CNLabelPhoneNumberMobile:
                        print("- Mobile: \(number.value.stringValue)")
                    case CNLabelPhoneNumberMain:
                        print("- Main: \(number.value.stringValue)")
                    default:
                        print("- Other: \(number.value.stringValue)")
                    }
                    //                    print("- \(String(describing: number.label)): \(number.value.stringValue)")
                    //                    print("- \( number.label) \(number.value.stringValue)")
                }
                self.contacts = fetchedContacts
            }
        } catch {
            // If there was an error, handle it here
            print("Please allow access to contacts to continue")
            
            // Popup screen saying why they need to allow contacts
        }
        
    }
    
}

func addPendingInviteCodes(randCode : String){
    
    let db = Firestore.firestore()
    
    let inviteCode = [
        "pendingInvites": FieldValue.arrayUnion([randCode]),
    ] as [String: Any]
    
    print(inviteCode)
    print("user id: \(String(describing: Auth.auth().currentUser?.uid.description))")
    
    //add new data point, no error will occur, no try catch is needed in this operation with no specific document
    db.collection("users").addDocument(data: inviteCode){ error in
        if let error = error {
            print("Error adding document: \(error.localizedDescription)")
        } else {
            print("Document added successfully")
        }
        
        
    }
}

func generateRandomCode() -> String {
    // Generate a random alphanumeric code (you can customize the length and characters)
    let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let codeLength = 6
    let randCode = String((0..<codeLength).map { _ in characters.randomElement()! })
    return randCode
}

func codeExistsInFirestore(_ code: String) -> Bool {
    var codeExists = false
    
    let db = Firestore.firestore()
    let usersCollection = db.collection("users")
    
    // Check if the code already exists in the "pendingInvites" array of any document in the "users" collection
    usersCollection.whereField("pendingInvites", arrayContains: code).getDocuments { snapshot, error in
        if let error = error {
            print("Error querying Firestore: \(error.localizedDescription)")
        } else {
            if let documents = snapshot?.documents, !documents.isEmpty {
                // Code exists
                codeExists = true
            }
        }
    }
    
    return codeExists
}


struct RequestUserContactsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestUserContactsView()
    }
}
