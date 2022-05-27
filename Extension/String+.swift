//
//  String+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import Foundation
import UIKit

extension String {
    func toYYYYMMDDHHMM() -> String {
        guard let number = Double(self) else { return ""}
        let date = NSDate(timeIntervalSince1970: number)
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "y/M/d hh:mm"
        // Convert Date to String
        return dateFormatter.string(from: date as Date)
    }

    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)

        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return boundingBox.width
    }
}
