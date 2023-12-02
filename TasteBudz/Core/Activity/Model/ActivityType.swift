//
//  ActivityType.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

enum ActivityType: Int, CaseIterable, Identifiable, Codable {
    case like
    case reply
    case follow
    
    var id: Int { return self.rawValue }
}
