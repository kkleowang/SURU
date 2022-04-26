//
//  SampleCommentCellTableViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit
import Kingfisher

class SampleCommentCellTableViewCell: UITableViewCell {

    @IBOutlet weak var commentIDLabel: UILabel!
    @IBOutlet weak var storNameLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    func layoutSampleCommentCell(store: Store?, comment: Comment?, account: Account?) {
        guard let store = store, let comment = comment, let account = account else {
            return
        }
        commentIDLabel.text = comment.commentID
        storNameLabel.text = store.name
        mealImageView.kf.setImage(with: URL(string: comment.mainImage))
        mealLabel.text = comment.meal
        timeLabel.text = String(comment.createdTime)
        authorLabel.text = account.name
        authorImageView.kf.setImage(with: URL(string: account.mainImage))
    }
}
