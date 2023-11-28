//
//  PhoneNumberPickerView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/16/23.
//

import SwiftUI

//struct PhoneNumberPickerView: View {
//    let contact: ContactModel
//    var selectedNumber: String?
//    var onSelection: ((String) -> Void)? // Closure to handle the selected number
//    
//    var body: some View {
//        VStack {
//            List {
//                ForEach(contact.phoneNumbers, id: \.self) { phoneNumber in
//                    Button(action: {
//                        selectedNumber = phoneNumber.number
//                        onSelection?(phoneNumber.number)
//                    }) {
//                        Text(phoneNumber.number)
//                            .padding()
//                            .background(selectedNumber == phoneNumber.number ? Color.blue : Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                    }
//                }
//            }
//        }
//    }
//}

struct PhoneNumberPickerView: View {
    let contact: ContactModel
    let phoneNumbers: [ContactPhoneNumber]
    
    // Callback closure to handle the selected number
    var selectionCallback: ((String) -> Void)?

    var body: some View {
        VStack {
            Text("Hello")
            List {
                ForEach(phoneNumbers, id: \.self) { phoneNumber in
                    Button(action: {
                        // Call the selectionCallback closure with the selected number
                        selectionCallback?(phoneNumber.number)
                    }) {
                        Text(phoneNumber.number)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}


//#Preview {
//a    PhoneNumberPickerView()
//}
