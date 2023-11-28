//
//  RequestUserContactsView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/15/23.
//

import SwiftUI
import Contacts

struct RequestUserContactsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                
                Task.init {
                    await fetchAllContacts();
                }
            }
    }
    
    func fetchAllContacts() async {
        
        // Fun this in the background async (Maybe right after user clicks sign up button)
        
        // Get access to the Contacts store
        let store = CNContactStore()
        
        // Specify which data keys we want to fetch: Name and Phone Number
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor] // "as" is used to cast the array of strings as a CNKeyDescriptor
        
        // Create fetch request
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        // Call method to fetch all contacts
        do {
            try store.enumerateContacts(with: fetchRequest) { contact, result in
                
                // Do something: Write code to send an invite to user's contacts
                
                // Step 1: When button is pressed
                
                // Step 2: Auto-generates a message
                
                // Step 3: Sends invite to contact
                
                // For now, we just print
                print(contact.givenName)
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
            }
        }
        catch {
            // If there was an error, handle it here
            print("Error")
        }
    }

}

#Preview {
    RequestUserContactsView()
}
