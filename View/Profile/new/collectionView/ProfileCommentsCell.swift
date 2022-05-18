//
//  ProfileCommentCollectionViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/6.
//

import UIKit
import Kingfisher

class ProfileCommentsCell: UICollectionViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    func layoutCell (comment: Comment) {
        mainImageView.loadImage(comment.mainImage, placeHolder: nil)
    }
}
