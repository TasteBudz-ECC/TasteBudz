//
//  NoteActionSheetOptions.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

enum NoteActionSheetOptions {
    case unfollow
    case mute
    case hide
    case report
    case block
    
    var title: String {
        switch self {
        case .unfollow:
            return "Unfollow"
        case .mute:
            return "Mute"
        case .hide:
            return "Hide"
        case .report:
            return "Report"
        case .block:
            return "Block"
        }
    }
}
