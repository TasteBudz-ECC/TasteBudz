//
//  ActivityBadgeView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct ActivityBadgeView: View {
    let type: ActivityType
    
    private var badgeColor: Color {
        switch type {
        case .like: return Color.theme.pink
        case .reply: return Color(.systemBlue)
        case .friend: return Color.theme.purple
        }
    }
    
    private var badgeImageName: String {
        switch type {
        case .like: return "heart.fill"
        case .reply: return "arrowshape.turn.up.backward.fill"
        case .friend: return "person.fill"
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.theme.primaryBackground)
            
            ZStack {
                Circle()
                    .fill(badgeColor)
                    .frame(width: 18, height: 18)

                
                Image(systemName: badgeImageName)
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
    }
}

struct ActivityBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityBadgeView(type: .friend)
    }
}
