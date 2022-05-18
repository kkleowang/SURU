//
//  StoreTagsCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit

class StoreTagsCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var iconImageView: UIImageView!
    
    func layoutForMealCell() {
        iconImageView.image = UIImage(named: "noodle")
    }
}
