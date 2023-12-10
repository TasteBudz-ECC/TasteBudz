//
//  AboutView.swift
//  TasteBudz
//
//  Created by student on 12/9/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image("GatherIcon_1024x1024")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding()
                
                Text("Our Purpose:")
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.leading, 15)
                
                Text("Gather is more than just meals; it's about fostering connections and shared experiences through affordable dining. Our platform brings people together, fostering friendships, and creating lasting memories over delicious, budget-friendly meals. We believe in the magic of bonding over food and provide the ideal platform for you to connect, meet, and eat with your friends and their extended circles.")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 15)
                
                Text("Frequently Asked Questions (FAQ)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading, 15)
                
                FAQItemView(question: "How does Gather ensure safety when meeting new people through the app?",
                            answer: "Safety is our priority. Gather connects users only with friends or friends of friends, minimizing interactions with strangers. Our notes feature allows you to plan meetups within your trusted network.")
                
                FAQItemView(question: "What is the advantage of recommending friends to the app?",
                            answer: "Recommending friends helps maintain a familiar atmosphere within the app. It ensures that connections are made within your social circles, fostering a comfortable environment for exploring new restaurants.")
                
                FAQItemView(question: "Why is recommending two restaurants a requirement?",
                            answer: "Recommending restaurants not only helps expand our database of affordable dining options but also encourages users to actively participate in creating and sharing their favorite places to eat.")
                
                FAQItemView(question: "What happens after recommending friends and two restaurants?",
                                           answer: "Recommending friends and two restaurants allows you to engage with other users on the app. It unlocks access to notes and interactions with your friends and their networks to discover and enjoy cheap eats together.")
                               
                               FAQItemView(question: " How can I make the most of the interactive gatherings feature?",
                                           answer: "Use the gatherings feature to invite your friends and extended network to explore affordable eateries with you. Post about restaurants you'd like to visit or ask if anyone's interested in joining you for a meal.")
                               
                               FAQItemView(question: "Can I explore restaurant recommendations from my friend network?",
                                           answer: "Yes! Discover restaurants recommended by your friends and mutual connections. The app showcases dining suggestions from people you trust, making it easier to plan gatherings at tried-and-true cheap eats spots.")
                               
//                               FAQItemView(question: "What if I don't have friends already using Gather?",
//                                           answer: "No worries! You can invite friends to the app and add those already using Gather. This step is crucial for expanding your network and discovering affordable dining experiences together.")
//
//                               FAQItemView(question: "How does Gather foster connections through food?",
//                                           answer: "Gather emphasizes connecting, meeting, and eating. It brings people together over inexpensive dining experiences, nurturing bonds and friendships by sharing delicious meals and common interests.")
                
                // Add more FAQItemView for other questions and answers
            }
            .padding()
        }
        .navigationTitle("About Gather")
    }
}

struct FAQItemView: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .font(.headline)
                .padding(.leading, 15)
            
            Text(answer)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.leading, 15)
        }
        .padding(.bottom)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
