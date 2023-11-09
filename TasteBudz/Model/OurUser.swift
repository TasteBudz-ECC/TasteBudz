//
//  User.swift
//  TasteBudz
//
//  Created by student on 11/4/23.
//

import Foundation

struct OurUser: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension OurUser {
    static var MOCK_USER = OurUser(id: NSUUID().uuidString, fullname: "Taste Budz", email: "test@gmail.com")
}
