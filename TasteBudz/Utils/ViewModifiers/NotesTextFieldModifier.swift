//
//  NotesTextFieldModifier.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI

struct NotesTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
