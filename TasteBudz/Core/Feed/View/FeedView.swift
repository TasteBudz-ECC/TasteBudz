//
//  FeedView.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI

//extension String {
//    func load() -> UIImage {
//        
//        
//        do{
//            guard let url = URL(string: self) else {
//                return UIImage()
//            }
//            
//            let data: Data = try Data(contentsOf: url)
//       
//            return UIImage(data: data)
//                ?? UIImage()
//        } catch {
//            
//        }
//        return UIImage()
//    }
//}

struct FeedView: View {
    var imageURL = URL(string:"https://images.prismic.io/bar-louie%2F28acb893-a2eb-4542-b063-d3c0cb3eb94c_739143_495794_1518558828478.jpg")
    
    var body: some View {

        ScrollView(){
            VStack{
                
                HStack{
                    Text("Explore Restaurant Options >>")
                        .font(.title)
                    
                }
                // View of restaurants
                ScrollView(.horizontal){
                    HStack(spacing: 20){
                        VStack {
                            AsyncImage(url: imageURL) { image in image
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:150, height: 200)
//                                    .border(Color.gray, width:5)
                                    .cornerRadius(20)
//
                               
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text("Bar Louie")
                        }
                        
                        ForEach(2..<10) {
                            Text("Restaurant \($0)")
                                .foregroundStyle(.white)
                                .font(.headline)
                                .frame(width: 150, height: 200)
                                .border(Color.gray, width:2)
                                .cornerRadius(20)
                                .background(.purple)
                            
                        }
                        
                    }
                }
                Rectangle()
                    .frame(width:400, height: 5)
//                 Text("See what everyone is up to!")
//                 // View of posts by users
//                 VStack(spacing: 20){
//                     ForEach(1..<10) {
//                         Text("Note \($0)")
//                             .foregroundStyle(.white)
//                             .font(.largeTitle)
//                             .frame(width: 350, height: 200)
//                             .background(.gray)
//                     }
=======
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(0 ... 10, id: \.self) { note in
                        NoteCell()
                        
                    }
                }
            }
            .refreshable {
                print("DEBUG: Refresh notes")
            }
            .navigationBarTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.black)

                }
            }
        }
    }
    
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FeedView()
        }
    }
}

