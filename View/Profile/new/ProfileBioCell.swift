//
//  ProfileBioCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/15.
//

import CHTCollectionViewWaterfallLayout
import UIKit

class ProfileBioCell: UITableViewCell {
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var badgeCollectionView: UICollectionView!

    //    var badge: [[Int]]?
    //
    //    var loginBadge:[Int] = []
    //    var commentBadge:[Int] = []
    //    var reportBadge:[Int] = []
    //    var likeBadge:[Int] = []
    //    var followBadge:[Int] = []

    //    var badgeCount: Int? {
    //        var count = 0
    //        guard let badge = badge else { return 0 }
    //        for data in badge {
    //            count += data.filter({$0 == 1}).count
    //        }
    //        return count
    //    }
    //    func configBadge() {
    //        guard let badge = badge else { return }
    //    loginBadge = badge[0]
    //    commentBadge = badge[1]
    //    reportBadge = badge[2]
    //    likeBadge = badge[3]
    //    followBadge = [4]
    //    }
    func layoutCell(bio: String) {
        bioLabel.text = bio
        //        badge = badgeState
    }
}

// extension ProfileBioCell: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return badgeCount ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BadgeCell.self), for: indexPath) as? BadgeCell else { return BadgeCell() }
//        guard let badgeCount = badgeCount else { return cell }
//
//        cell.layoutCell(image: <#T##UIImage?#>, text: <#T##String#>, textColor: <#T##UIColor#>, waringText: <#T##String#>)
//    }
//
//
// }
