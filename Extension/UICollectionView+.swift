//
//  UICollectionView+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/6.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerCellWithNib(identifier: String, bundle: Bundle?) {
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: identifier)
    }

    func registerHeaderWithNib(identifier: String, bundle: Bundle?) {
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .B4
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .medium(size: 18)
        messageLabel.sizeToFit()

        backgroundView = messageLabel
    }

    func restore() {
        backgroundView = nil
    }
}

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
