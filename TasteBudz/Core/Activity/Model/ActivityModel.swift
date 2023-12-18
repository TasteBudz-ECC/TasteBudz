//
//  ActivityModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct ActivityModel: Identifiable, Codable, Hashable {
    @DocumentID private var activityModelId: String?
    let type: ActivityType
    let senderUid: String
    let timestamp: Timestamp
    var noteId: String?
    
    var user: User?
    var note: Note?
    var isFriends: Bool?
    
    var id: String {
        return activityModelId ?? NSUUID().uuidString
    }
}
