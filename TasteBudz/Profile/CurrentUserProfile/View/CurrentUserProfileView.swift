//
//  CurrentUserProfileView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct CurrentUserProfileView: View {
    private var didNavigate: Bool? = false
    
    init(didNavigate: Bool? = false) {
        self.didNavigate = didNavigate
    }

    var body: some View {
        Group {
            if let didNavigate, didNavigate == true {
                CurrentUserProfileContentView()
                    .padding()
            } else {
                NavigationStack {
                    CurrentUserProfileContentView()
                        .padding()
                }
            }
        }
    }
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView()
    }
}
