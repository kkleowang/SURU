//
//  BadgeCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/7.
//

import UIKit

class BadgeCell: UICollectionViewCell {

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeNameLabel: UILabel! {
        didSet {
            badgeNameLabel.font = .medium(size: 12)
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
