//
//  CircularProfileImageView.swift
//  TasteBudz
//
//  Created by student on 11/30/23.
//

import SwiftUI

struct CircularProfileImageView: View {
    var body: some View {
        Image("default_profile_image")
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

struct CircularProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImageView()
    }
}
