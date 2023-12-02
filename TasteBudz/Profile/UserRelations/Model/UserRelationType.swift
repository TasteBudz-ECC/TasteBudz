//
//  UserRelationType.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

enum UserRelationType: Int, CaseIterable, Identifiable {
    case followers
    case following
    
    var title: String {
        switch self {
        case .followers: return "Followers"
        case .following: return "Following"
        }
    }
    
    var id: Int { return self.rawValue }
}

