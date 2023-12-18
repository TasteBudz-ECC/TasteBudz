//
//  UserRelationType.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

enum UserRelationType: Int, CaseIterable, Identifiable {
//    case followers
//    case following
    case friends
    case friendNetwork
    
    var title: String {
        switch self {
//        case .followers: return "Followers"
//        case .following: return "Following"
        case .friends: return "Friends"
        case .friendNetwork: return "Friend Network"
        }
    }
    
    var id: Int { return self.rawValue }
}

