//
//  StoreCardViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/23.
//

import Foundation
import UIKit
import Cosmos

class StoreCardCell: UICollectionViewCell {
    @IBOutlet weak private var leftImageView: UIImageView! {
        didSet {
            leftImageView.clipsToBounds = true
            leftImageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak private var middleImageView: UIImageView! {
        didSet {
            middleImageView.clipsToBounds = true
            middleImageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak private var rightImageView: UIImageView! {
        didSet {
            rightImageView.clipsToBounds = true
            rightImageView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var avgRatingView: CosmosView!
    @IBOutlet weak private var ratingCountLabel: UILabel!
    @IBOutlet weak private var tagsStackView: UIStackView!
    @IBOutlet weak private var localtionAreaLabel: UILabel!
    @IBOutlet weak private var openingWaringLabel: UILabel!
    @IBOutlet weak private var timeUntillLabel: UILabel!
    
    @IBOutlet weak private var distanceLabel: UILabel!
    func layoutCardView(dataSource: Store, areaName: String, distance: Double) {
        self.backgroundColor = .black.withAlphaComponent(0.7)
        self.clipsToBounds = true
        self.cornerForAll(radii: 10)
        self.nameLabel.text = dataSource.name
        self.localtionAreaLabel.text = areaName
        self.distanceLabel.text = String("\(distance.ceiling(toDecimal: 1)) 公里")
       
    }
}
