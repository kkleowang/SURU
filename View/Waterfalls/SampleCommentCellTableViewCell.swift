//
//  SampleCommentCellTableViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import Kingfisher
import UIKit

class SampleCommentCellTableViewCell: UITableViewCell {
    @IBOutlet var commentIDLabel: UILabel!
    @IBOutlet var storNameLabel: UILabel!
    @IBOutlet var mealImageView: UIImageView!
    @IBOutlet var mealLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var authorImageView: UIImageView!

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
