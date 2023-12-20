//
//  GetRestDetailsFunctions.swift
//  TasteBudz
//
//  Created by Litao Li on 12/14/23.
//

import Foundation
import SwiftUI

func buildAddress(location: LocationID?) -> String {
    guard let location = location else {
        return "N/A"
    }

    var addressComponents: [String] = []

    if let address1 = location.address1, !address1.isEmpty {
            addressComponents.append(address1)
        }

        if let address2 = location.address2, !address2.isEmpty {
            addressComponents.append(address2)
        }

        if let address3 = location.address3, !address3.isEmpty {
            addressComponents.append(address3)
        }

        if let city = location.city, !city.isEmpty {
            addressComponents.append(city)
        }

        if let state = location.state, !state.isEmpty {
            addressComponents.append(state)
        }

        if let zipCode = location.zipCode, !zipCode.isEmpty {
            addressComponents.append(zipCode)
        }

        return addressComponents.joined(separator: ", ")
    }


//func getFormattedRestaurantHours(from businessDetails: BusinessDetails) -> String? {
//    guard let hours = businessDetails.hours?.first?.hourOpen else {
//        return nil
//    }
//
//    var hoursString = ""
//    for openHour in hours {
//        if let start = openHour.start,
//           let end = openHour.end,
//           let day = openHour.day {
//            let dayString = getDayString(for: day)
//            let timeRange = "\(start.prefix(2)):\(start.suffix(2)) - \(end.prefix(2)):\(end.suffix(2))"
//            hoursString.append("\(dayString): \(timeRange)\n")
//        }
//    }
//
//    return hoursString
//}
//
func getDayString(for day: Int) -> String {
    switch day {
    case 0: return "Sunday"
    case 1: return "Monday"
    case 2: return "Tuesday"
    case 3: return "Wednesday"
    case 4: return "Thursday"
    case 5: return "Friday"
    case 6: return "Saturday"
    default: return ""
    }
}

func getFormattedRestaurantHours(from businessDetails: BusinessDetails) -> String? {
    guard let hours = businessDetails.hours?.first?.hourOpen else {
        return nil
    }

    var hoursString = ""
    for openHour in hours {
        if let start = openHour.start,
           let end = openHour.end,
           let day = openHour.day {
            let dayString = getDayString(for: day)

            // Convert military time to 12-hour format with AM/PM
            let formattedStartTime = formatMilitaryTimeTo12Hour(time: start)
            let formattedEndTime = formatMilitaryTimeTo12Hour(time: end)

            let timeRange = "\(formattedStartTime) - \(formattedEndTime)"
            hoursString.append("\(dayString): \(timeRange)\n")
        }
    }

    return hoursString
}

func formatMilitaryTimeTo12Hour(time: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HHmm"

    if let date = dateFormatter.date(from: time) {
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    } else {
        return time
    }
}

struct StarRatingView: View {
    let rating: Double
    let spacing: CGFloat
    
    init(rating: Double, spacing: CGFloat = 4.0) {
        self.rating = rating
        self.spacing = spacing
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .foregroundColor(Color(UIColor(hex: 0xf7b2ca)))
            }
        }
    }
}
