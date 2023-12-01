//
//  ContentViewOfficial.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI

struct ContentViewOfficial: View {
    @StateObject var viewModel = ContentViewOfficialModel()
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                NotesTabView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentViewOfficial_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewOfficial()
    }
}
