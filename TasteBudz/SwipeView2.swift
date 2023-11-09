//
//  SwipeView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/3/23.
//

import SwiftUI

struct SwipeView2: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color.white) // Set the background color
            }
            VStack {
                VStack(alignment: .leading) {
                    Text("Restaurant Name2")
                        .font(.title)
                    HStack {
                        Text("Type of Restaurant")
                        Text("$$") // Create a function for this: if btw a certain range then $$$ is assigned
                    }.foregroundColor(Color.gray)
                    
                    ZStack {
                        Rectangle() // grab image from yelp
                            .frame(width: 350, height: 300)
                            .foregroundColor(Color.green)
                            .cornerRadius(20)

                        Text("Image")
                            .foregroundColor(Color.white)                    }
                    
                    Text("Overview")
                        .foregroundColor(Color.gray)
                }
                Text("Description ndkhgfd ljldsfjs kldfjdslfjdlfjd slkfjsdf lksdjfkldsjfk fdkffkjsdfjkslfkjsdfkjsdf")
                    .frame(width: 300)
                    .padding()
                
                VStack(alignment: .leading) { // IDK why this is not leading
                    HStack {
                        Image(systemName: "pin")
                        Text("Address")
                    }.padding(.bottom, 10)
                    
                    HStack { // Need to make image at the top; need to be same line as Monday
                        Image(systemName: "clock")
                        VStack (alignment: .leading){ // Create function to get info from Yelp
                            Text("Monday 11am-12am")
                            Text("Tuesday 11am-12am")
                            Text("Wednesday 11am-12am")
                            Text("Thursday 11am-12am")
                            Text("Friday 11am-12am")
                            Text("Saturday 11am-12am")
                            Text("Sunday 11am-12am")
                        }
                    }
                }
                
            }
    
            
            //            Rectangle()
            //                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            //                .foregroundColor(Color.blue) // Set the background color
        }
    }
}

//#Preview {
//    SwipeView2()
//}


//ZStack{
//    Rectangle()
//        .frame(width: 300, height: 300)
//        .foregroundColor(.purple)
//    Image("G1 200x200")
//    Text("1")
//        .foregroundColor(.white)
//        .font(.system(size: 70, weight: .bold))
//}
