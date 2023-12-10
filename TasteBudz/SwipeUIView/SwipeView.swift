//
//  SwipeView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/3/23.
//

import SwiftUI


// Create an array of network
// Search for user id in firebase in the friends collection
// Add the friends to network array
// For every friend in that array, search for their friends, add those friends to network

struct SwipeView: View {
    var body: some View {
        
        ScrollView(){
            /// add image for now
            let imageURL_swipeview = URL(string:"https://images.prismic.io/bar-louie%2F28acb893-a2eb-4542-b063-d3c0cb3eb94c_739143_495794_1518558828478.jpg")
            ///
            
            ZStack {
                GeometryReader { geometry in
                    Rectangle()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .foregroundColor(Color.white) // Set the background color
                }
                VStack {
                    VStack(alignment: .leading) {
                        //                    Text("Restaurant Name2")
                        Text("Bar Louie")
                            .font(.title)
                        HStack {
                            //                        Text("Type of Restaurant")
                            Text("Bar and Grill")
                            Text("$$") // Create a function for this: if btw a certain range then $$$ is assigned
                            
                            Image(systemName: "plus")
                                .frame(alignment:.topTrailing)
                            
                        }.foregroundColor(Color.gray)
                        
                        ZStack {
                            Rectangle() // grab image from yelp
                                .frame(width: 350, height: 300)
                                .foregroundColor(Color.blue)
                                .cornerRadius(20)
                            
                            //                        Text("Image")
                            //                            .foregroundColor(Color.white)
                            
                            AsyncImage(url: imageURL_swipeview) { image in image
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:350, height: 300)
                                    .cornerRadius(20)
                                /*border(Color.gray, width:2)*/
                                
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        Text("Overview")
                            .foregroundColor(Color.gray)
                    }
                    Text("Experience your local bar with handcrafted martinis, cocktails and a scratch kitchen during happy hour and late night!")
                        .frame(width: 300)
                        .padding()
                    
                    VStack(alignment: .leading) { // IDK why this is not leading
                        HStack {
                            Image(systemName: "pin")
                            Text("1325 S Halsted St, Chicago, IL 60607")
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
}

func populateNetwork() {
    // Create an array of network
    // Search for user id in firebase in the friends collection
    // Add the friends to network array
    // For every friend in that array, search for their friends, add those friends to network

}


struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView()
    }
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
