//
//  User.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String? //optional profile image
    var bio: String? //optional bio
}
