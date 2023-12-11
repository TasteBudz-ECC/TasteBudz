//
//  NGButton.swift
//  TasteBudz
//
//  Created by Arely Herrera on 12/7/23.
//
//This is the TLButton on video but here: NGButton that is references on New GatheringView
//This is just a custom button that can be used in other pages/views
import SwiftUI
struct NGButton: View {
    let title: String
    let background: Color
    let action: () -> Void //action is a closure that takes in no arguments
    
    var body: some View {
        Button{
            //pass in an action, what happens when the button is tapped
            action()
        } label: {
            ZStack {
                RoundedRectangle (cornerRadius: 10)
                    .foregroundColor(background)
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
        .padding() //This is 48.44 on the video
    }
}

struct NGButton_Previews: PreviewProvider {
    static var previews: some View {
        NGButton(title: "Value", background: .pink) {
        }
    }
}
