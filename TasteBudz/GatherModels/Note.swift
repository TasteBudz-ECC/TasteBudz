//
//  Note.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Note: Identifiable, Codable, Hashable {
    @DocumentID private var noteId: String?
    let ownerUid: String
    let caption: String
    let timestamp: Timestamp
    var likes: Int
    var imageUrl: String?
    var replyCount: Int
    
    var user: User?
    var didLike: Bool? = false
    
    var id: String {
        return noteId ?? NSUUID().uuidString
    }
    
    // Implement Equatable
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id // You might need to compare other properties for equality
    }
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // You might need to combine other properties here for hashing
    }
}

struct GatheringDetails: Codable {
    // Define properties for GatheringDetails
    var restaurantName: String
    var selectedDate: Date
    var gatheringDescription: String
}

