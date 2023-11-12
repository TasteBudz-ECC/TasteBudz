//
//  InitialView.swift
//  TasteBudz
//
//  Created by student on 11/4/23.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group {
              if viewModel.userSession != nil {
                ProfileView()
              } else {
                  SigningUpLoginView()
              }
        }
    }
}
#Preview {
    InitialView().environmentObject(AuthViewModel())
    // this ui file is to decide where to take user depending on if the user already has an account :)
}
// comment
