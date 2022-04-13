//
//  UIColor+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit

private enum SURUColor: String {

    // swiftlint:disable identifier_name
    case C1

    case C2

    case C3

    case C4

    case C5

    case C6
    
    case C7
    
    case B1

    case B2

    case B3

    case B4

    case B5

    case B6
    
    case G7
    
}

extension UIColor {

    static let C1 = STColor(.C1)
    
    static let C2 = STColor(.C2)
    
    static let C3 = STColor(.C3)
    
    static let C4 = STColor(.C4)
    
    static let C5 = STColor(.C5)
    
    static let C6 = STColor(.C6)
    
    static let C7 = STColor(.C7)
    
    static let B1 = STColor(.B1)
    
    static let B2 = STColor(.B2)
    
    static let B3 = STColor(.B3)
    
    static let B4 = STColor(.B4)
    
    static let B5 = STColor(.B5)
    
    static let B6 = STColor(.B6)
    
    static let G7 = STColor(.G7)

    private static func STColor(_ color: SURUColor) -> UIColor? {

        return UIColor (named: color.rawValue)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
