//
//  ActivityFilterViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

enum ActivityFilterViewModel: Int, CaseIterable, Identifiable, Codable {
    case all
    case replies
    case friends
    case friendNetwork

    var title: String {
        switch self {
        case .all: return "All"
        case .replies: return "Replies"
        case .friends:
            return "Friends"
        case .friendNetwork:
            return "Friend of Friends"
        }
    }
    
    var id: Int { return self.rawValue }
}
