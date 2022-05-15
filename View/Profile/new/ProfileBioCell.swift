//
//  ProfileBioCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/15.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class ProfileBioCell: UITableViewCell {

    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var badgeCollectionView: UICollectionView!
    
    var badge: [[Int]]?
    func layoutCell(bio: String, badgeState: [[Int]]) {
        bioLabel.text = bio
        badge = badgeState
        
//        badgeCollectionView.dataSource = self
//        badgeCollectionView.delegate = self
    }
}
//extension ProfileBioCell: UICollectionViewDataSource, UICollectionViewDelegate {
//
//}
