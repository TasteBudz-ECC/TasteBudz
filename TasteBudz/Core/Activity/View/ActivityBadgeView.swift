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
        case .follow: return Color.theme.purple
        case .reply: return Color(.systemBlue)
        case .friendAdded:
            return Color(.systemBlue)
        case .friendNetworkUpdated:
            return Color(.systemRed)
        }
    }
    
    private var badgeImageName: String {
        switch type {
        case .like: return "heart.fill"
        case .follow: return "person.fill"
        case .reply: return "arrowshape.turn.up.backward.fill"
        case .friendAdded:
            return "person.2"
        case .friendNetworkUpdated:
            return "person.3"
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
        ActivityBadgeView(type: .follow)
    }
}
