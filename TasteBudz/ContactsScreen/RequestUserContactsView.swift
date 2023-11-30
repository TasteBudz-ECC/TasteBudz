//
//  RequestUserContactsView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/15/23.
//

import SwiftUI
import Contacts

struct RequestUserContactsView: View {
    @State private var contacts = [ContactModel]()
    @State private var selectedContact: ContactModel?
    @State private var selectedNumber: String?

    
    var body: some View {
        ScrollView {
            VStack {
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
                
                
                // Displays each contact
                ForEach(contacts) { contact in
                    HStack {
                        Text(contact.fullName)
                        Spacer()
                        
                        // When button is clicked, an invite it sent
                        Button(action: {
                            contact.sendInvite()
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
    
    //    func isSelected(_ contact: ContactModel) -> Bool {
    //        selectedContacts.contains(where: { $0.id == contact.id })
    //    }
    //
    //    func toggleSelected(_ contact: ContactModel) {
    //        if let index = selectedContacts.firstIndex(where: { $0.id == contact.id }) {
    //            selectedContacts.remove(at: index)
    //        } else {
    //            selectedContacts.append(contact)
    //        }
    //    }
    
    //    func getIndex(_ contact: ContactModel) -> Int {
    //        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
    //            return index
    //        }
    //        return 0
    //    }
    
    // Function to send invites for selected contacts
    //    func sendInvite() {
    ////        let selectedContacts = contacts.filter { $0.isSelected }
    ////
    ////        for contact in selectedContacts {
    //            // Check if the contact has multiple numbers
    //            if contact.phoneNumbers.count > 1 {
    //                // Show a picker to let the user choose the phone number
    //                // You can use an action sheet or a custom picker, depending on your design
    //                // For simplicity, I'll use an action sheet
    //                showNumberPicker(for: contact)
    //            } else {
    //                // If only one number, directly send the invite
    //                contact.sendInvites(to: contact.phoneNumbers.first?.number ?? "")
    //            }
    ////        }
    //    }
    
}



struct RequestUserContactsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestUserContactsView()
    }
}
