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
}
