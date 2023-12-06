//
//  String.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import UIKit

extension String {
   func sizeUsingFont(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
