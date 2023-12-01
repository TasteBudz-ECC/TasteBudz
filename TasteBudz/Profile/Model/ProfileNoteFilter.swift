//
//  ProfileNoteFilter.swift
//  TasteBudz
//
//  Created by student on 11/30/23.
//

import Foundation

enum ProfileNoteFilter: Int, CaseIterable, Identifiable {
    // more cases can be added here like if you want the profile view to have a user's liked restaurants it can go here, ex: case likedrestaurantes
    case notes
    case replies
    
    var title: String {
        switch self {
          
        case .notes: return "Notes"
        case .replies: return "Replies"
            
        }
    }
    var id: Int { return self.rawValue }
}
