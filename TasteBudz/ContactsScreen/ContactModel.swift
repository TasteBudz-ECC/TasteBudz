//
//  ContactModel.swift
//  TasteBudz
//
//  Created by Litao Li on 11/16/23.
//

import Foundation

struct ContactModel: Identifiable {
    let id = UUID()
    let fullName: String
    let phoneNumbers: [ContactPhoneNumber]
    var isSelected: Bool = false // Add isSelected property

    // Function to toggle the isSelected property
    mutating func toggleSelected() {
        isSelected.toggle()
    }

    // Function to send invites
    func sendInvites(contact: ContactModel, number: String) {
        // Implement the logic to send invites here
        // You can access fullName, phoneNumbers, and isSelected properties
        // Example: Print information for demonstration
        print("Sending invite to \(contact.fullName) at \(number)")
    }

    // Computed property to get selected phone numbers
    var selectedPhoneNumbers: [ContactPhoneNumber] {
        return phoneNumbers.filter { $0.isSelected }
    }
}
