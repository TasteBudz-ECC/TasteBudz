//
//  UserRelationType.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

enum UserRelationType: Int, CaseIterable, Identifiable {
    case friends
    case friendNetwork
    
    var title: String {
        switch self {
        case .friends: return "Friends"
        case .friendNetwork: return "Mutuals"
        }
    }
    
    var id: Int { return self.rawValue }
}

