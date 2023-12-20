//
//  NoteActionSheetOptions.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

enum NoteActionSheetOptions {
//    case unfriend
//    case mute
//    case hide
    case report
//    case block
    
    var title: String {
        switch self {
//        case .unfriend:
//            return "Unfriend"
//        case .mute:
//            return "Mute"
//        case .hide:
//            return "Hide"
        case .report:
            return "Report"
//        case .block:
//            return "Block"
        }
    }
}
