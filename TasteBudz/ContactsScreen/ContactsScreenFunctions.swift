////
////  ContactsScreenFunctions.swift
////  TasteBudz
////
////  Created by Litao Li on 12/8/23.
////
//
//import Foundation
//import Contacts
//
//extension RequestUserContactsView {
//    func fetchAllContacts() async {
//        var fetchedContacts: [ContactModel] = []
//        
//        // Fun this in the background async (Maybe right after user clicks sign up button)
//        
//        // Get access to the Contacts store
//        let store = CNContactStore()
//        
//        // Specify which data keys we want to fetch: Name and Phone Number
//        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor] // "as" is used to cast the array of strings as a CNKeyDescriptor
//        
//        // Create fetch request
//        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
//        
//        // Call method to fetch all contacts
//        do {
//            try store.enumerateContacts(with: fetchRequest) { contact, result in
//                let fullName = "\(contact.givenName) \(contact.familyName)"
//                let phoneNumbers = contact.phoneNumbers.map { phoneNumber in
//                    switch phoneNumber.label {
//                    case CNLabelPhoneNumberMobile:
//                        return ContactPhoneNumber(type: .mobile, number: phoneNumber.value.stringValue)
//                    case CNLabelPhoneNumberMain:
//                        return ContactPhoneNumber(type: .main, number: phoneNumber.value.stringValue)
//                    default:
//                        return ContactPhoneNumber(type: .other, number: phoneNumber.value.stringValue)
//                    }
//                }
//                
//                let newContact = ContactModel(fullName: fullName, phoneNumbers: phoneNumbers)
//                fetchedContacts.append(newContact)
//                
//                // Do something: Write code to send an invite to user's contacts
//                
//                // Step 1: When button is pressed
//                
//                // Step 2: Auto-generates a message
//                
//                // Step 3: Sends invite to contact
//                
//                // For now, we just print
//                print(contact.givenNßame, contact.familyName)
//                //                print(contact.familyName)
//                for number in contact.phoneNumbers {
//                    
//                    switch number.label {
//                        
//                    case CNLabelPhoneNumberMobile:
//                        print("- Mobile: \(number.value.stringValue)")
//                    case CNLabelPhoneNumberMain:
//                        print("- Main: \(number.value.stringValue)")
//                    default:
//                        print("- Other: \(number.value.stringValue)")
//                    }ß
//                    //                    print("- \(String(describing: number.label)): \(number.value.stringValue)")
//                    //                    print("- \( number.label) \(number.value.stringValue)")
//                }
//                self.contacts = fetchedContacts
//            }
//        } catch {
//            // If there was an error, handle it here
//            print("Please allow access to contacts to continue")
//            
//            // Popup screen saying why they need to allow contacts
//        }
//        
//    }
//}
