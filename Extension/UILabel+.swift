//
//  UILabel+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit

extension UILabel {
    //字距
    @IBInspectable var characterSpacing: CGFloat {

        set {

            if let labelText = text, labelText.isEmpty != true {

                let attributedString = NSMutableAttributedString(attributedString: attributedText!)

                attributedString.addAttribute(
                    NSAttributedString.Key.kern,
                    value: newValue,
                    range: NSRange(location: 0, length: attributedString.length - 1)
                )

                attributedText = attributedString
            }
        }

        get {
            // swiftlint:disable force_cast
            return attributedText?.value(forKey: NSAttributedString.Key.kern.rawValue) as! CGFloat
            // swiftlint:enable force_cast
        }

    }
}
