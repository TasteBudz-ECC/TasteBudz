//
//  InitialView.swift
//  TasteBudz
//
//  Created by student on 11/12/23.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                ProfileView()
            } else {
                SignupLoginView()
            }
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView().environmentObject(AuthViewModel()) // Provide an AuthViewModel as an environment object for the preview
    }
}
