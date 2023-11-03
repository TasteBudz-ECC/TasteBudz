//
//  SwipeView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/3/23.
//

import SwiftUI

struct SwipeView: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color.white) // Set the background color
            }
            VStack {
                VStack(alignment: .leading) {
                    Text("Restaurant Name")
                        .font(.title)
                    HStack {
                        Text("Type of Restaurant")
                        Text("$$") // Create a function for this: if btw a certain range then $$$ is assigned
                    }.foregroundColor(Color.gray)
                    
                    ZStack {
                        Rectangle() // grab image from yelp
                            .frame(width: 350, height: 300)
                            .foregroundColor(Color.blue)
                            .cornerRadius(20)

                        Text("Image")
                            .foregroundColor(Color.white) // Set the text color
                    }
                    
                    Text("Overview")
                        .foregroundColor(Color.gray)
                }
                Text("Description ndkhgfd ljldsfjs kldfjdslfjdlfjd slkfjsdf lksdjfkldsjfk fdkffkjsdfjkslfkjsdfkjsdf")
                    .frame(width: 300)
                    .padding()
                
                HStack() {
                    Image(systemName: "pin")
                }
                
            }
    
            
            //            Rectangle()
            //                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            //                .foregroundColor(Color.blue) // Set the background color
        }
    }
}

#Preview {
    SwipeView()
}


//ZStack{
//    Rectangle()
//        .frame(width: 300, height: 300)
//        .foregroundColor(.purple)
//    Image("G1 200x200")
//    Text("1")
//        .foregroundColor(.white)
//        .font(.system(size: 70, weight: .bold))
//}
