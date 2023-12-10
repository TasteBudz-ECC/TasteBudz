//
//  NetworkTest.swift
//  TasteBudzTests
//
//  Created by Litao Li on 12/10/23.
//

import Foundation
import TasteBudz


func main() async {
    let currentUserID = "Alex"
    let result = try await TasteBudz.populateNetwork(forUserID: currentUserID)

    print("User's Network: \(result)")
}

// Call the main function to run the script
Task {
    await main()
}
