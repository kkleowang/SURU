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
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func tapmoreButton(_ sender: Any) {
        self.delegate?.didTapMoreButton(self, targetUserID: targetUserID)
    }
    
    func layoutCell(commentMessage: Message, author: Account) {
        authorImage.loadImage(author.mainImage, placeHolder: UIImage(named: "mainImage"))
        authorImage.clipsToBounds = true
        authorImage.layer.cornerRadius = authorImage.frame.width
        
        authorName.text = author.name
        authorName.setDefultFort()
        
        let date = Date(timeIntervalSince1970: commentMessage.createdTime)
        commentDate.text = date.timeAgoDisplay()
        commentDate.setDefultFort()
        
        commentContent.setDefultFort()
        commentContent.text = commentMessage.message
        
        
    }
}
