//
//  GetRestDetailsFunctions.swift
//  TasteBudz
//
//  Created by Litao Li on 12/14/23.
//

import Foundation

func buildAddress(location: LocationID?) -> String {
    guard let location = location else {
        return "N/A"
    }

    var addressComponents: [String] = []

    if let address1 = location.address1 {
        addressComponents.append(address1)
    }

    if let address2 = location.address2 {
        addressComponents.append(address2)
    }

    if let address3 = location.address3 {
        addressComponents.append(address3)
    }

    if let city = location.city {
        addressComponents.append(city)
    }

    if let state = location.state {
        addressComponents.append(state)
    }

    if let zipCode = location.zipCode {
        addressComponents.append(zipCode)
    }

    return addressComponents.joined(separator: ", ")
}

func buildHours(hours: [Hour]?) -> String {
    guard let hours = hours, !hours.isEmpty else {
        return "N/A"
    }

    var formattedHours: [String] = []

    for hour in hours {
        if let open = hour.hourOpen,
           let start = open.first?.start,
           let end = open.first?.end,
           let day = open.first?.day {
            let dayString = formatDay(day: day)
            let formattedHour = "\(dayString): \(start) - \(end)"
            formattedHours.append(formattedHour)
        }
    }

    return formattedHours.joined(separator: "\n")
}

func formatDay(day: Int) -> String {
    // You may want to customize this based on your needs
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    return daysOfWeek[day]
}
