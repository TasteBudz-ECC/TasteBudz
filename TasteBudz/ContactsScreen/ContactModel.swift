//
//  ContactModel.swift
//  TasteBudz
//
//  Created by Litao Li on 11/16/23.
//

import Foundation
import SwiftUI

struct ContactPhoneNumber: Hashable {
    enum PhoneNumberType {
        case mobile
        case main
        case other
    }
    
    let type: PhoneNumberType
    let number: String
//    var isSelected: Bool = false // Add isSelected property
//    
//    // Function to toggle the isSelected property
//    mutating func toggleSelected() {
//        isSelected.toggle()
//    }
}

struct ContactModel: Identifiable {
    let id = UUID()
    let fullName: String
    let phoneNumbers: [ContactPhoneNumber]
    var isSelected: Bool = false // Add isSelected property
//    contact.imageData = image?.jpegData(compressionQuality: 1.0)
    
    // Function to toggle the isSelected property
    mutating func toggleSelected() {
        isSelected.toggle()
    }
    
    func sendInvite() {
        // Check if the contact has multiple numbers
        /* if phoneNumbers.count > 1 {
            print("\(fullName) has more than 1 phone number. Please choose which phone number to send an invite to.")
            // Show a picker to let the user choose the phone number
            var picker = PhoneNumberPickerView(contact: self, phoneNumbers: phoneNumbers)
            print("Hello")
//            print(picker)
            // Handle the selected number in PhoneNumberPickerView using a callback
            picker.selectionCallback = { selectedNumber in
                // Implement logic based on user selection
                // For example, you can now call your sendInvite function
                sendInvites(to: selectedNumber)
            }
        } else {
            // If only one number, directly send the invite
            sendInvites(to: phoneNumbers.first?.number ?? "")
        }
        */
        
        // For now send text to first number available
        sendInvites(to: phoneNumbers.first?.number ?? "")
    }
    
    
    
    // Function to send invite to chosen phone number
    func sendInvites(to number: String) {
        let sms: String = "sms:\(number)&body=try this with me [link to download Gather app]"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
        print("Sending invite to \(fullName) at \(number)")
        // Add code, that pops up to messages and allow user to send an automated message
    }
    
}