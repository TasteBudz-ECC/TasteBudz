//
//  CreateNoteDummyView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct CreateNoteDummyView: View {
    @State private var presented = false
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack { }
        .onAppear { presented = true }
        .sheet(isPresented: $presented) {
            CreateNoteView(tabIndex: $tabIndex)
        }
    }
}

struct CreateNoteDummyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNoteDummyView(tabIndex: .constant(0))
    }
}
