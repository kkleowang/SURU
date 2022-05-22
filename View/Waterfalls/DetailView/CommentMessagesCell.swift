//
//  CommentsCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/13.
//

import UIKit
protocol CommentMessagesCellDelegate: AnyObject {
    func didTapMoreButton(_ view: CommentMessagesCell, targetUserID: String?)
}

class CommentMessagesCell: UITableViewCell {
    weak var delegate: CommentMessagesCellDelegate?
    var targetUserID: String?

    @IBOutlet var authorImage: UIImageView!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var commentDate: UILabel!
    @IBOutlet var commentContent: UILabel!
    @IBOutlet var moreButton: UIButton!

    @IBAction func tapmoreButton(_: Any) {
        delegate?.didTapMoreButton(self, targetUserID: targetUserID)
    }

    func layoutCell(commentMessage: Message, author: Account) {
        if commentMessage.userID == author.userID {
            moreButton.isHidden = true
        }
        targetUserID = commentMessage.userID
        authorImage.loadImage(author.mainImage, placeHolder: UIImage(named: "mainImage"))
        authorImage.clipsToBounds = true
        authorImage.layer.cornerRadius = authorImage.frame.width / 2

        authorName.text = author.name

        let date = Date(timeIntervalSince1970: commentMessage.createdTime)
        commentDate.text = date.timeAgoDisplay()
        commentContent.setDefultFort()
        commentContent.text = commentMessage.message
    }
}
