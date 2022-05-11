//
//  StoreCommentCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/11.
//

import UIKit
import Kingfisher

protocol StoreCommentCellDelegate: AnyObject {
    func didtapLike(_ view: StoreCommentCell, targetComment: Comment?)
    func didtapfollow(_ view: StoreCommentCell, targetUserID: String?)
    func didtapMore(_ view: StoreCommentCell, targetUserID: String?)
    func didtapAuthor(_ view: StoreCommentCell, targetUserID: String?)
}

class StoreCommentCell: UITableViewCell {
    
    var targetUserID: String?
    var commentData: Comment?
    var loginStatus = false
    var likeStatus = false
    var followStatus = false
    weak var delegate: StoreCommentCellDelegate?
    @IBAction func tapLike(_ sender: Any) {
        self.delegate?.didtapLike(self, targetComment: commentData)
    }
    @IBAction func tapFollow(_ sender: Any) {
        self.delegate?.didtapfollow(self, targetUserID: targetUserID)
    }
    @IBAction func tapMore(_ sender: Any) {
        self.delegate?.didtapMore(self, targetUserID: targetUserID)
    }
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorFollowerLabel: UILabel!
    @IBOutlet weak var authorStackView: UIStackView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var commentImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
 
    func layoutView(author: Account, comment: Comment, isLogin: Bool, isFollow: Bool, isLike: Bool) {
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        loginStatus = isLogin
        likeStatus = isLike
        followStatus = isFollow
        commentData = comment
        targetUserID = comment.userID
        
        authorImageView.layer.cornerRadius = authorImageView.bounds.width / 2
        authorImageView.layer.borderWidth = 1.0
        authorImageView.layer.borderColor = UIColor.white.cgColor
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.kf.setImage(with: URL(string: author.mainImage), placeholder: UIImage(named: "AppIcon"))
        
        authorNameLabel.text = author.name
        authorFollowerLabel.text = "\(author.follower.count) 人追蹤中"
        
        commentImageView.kf.setImage(with: URL(string: comment.mainImage), placeholder: UIImage(named: "AppIcon"))
        let tapAuthor = UITapGestureRecognizer(target: self, action: #selector(tapAuthorView))
        let doubleTapImage = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        commentImageView.addGestureRecognizer(doubleTapImage)
        doubleTapImage.numberOfTapsRequired = 2
        commentImageView.isUserInteractionEnabled = true
        let likeCount = comment.likedUserList.count
        
        authorStackView.isUserInteractionEnabled = true
        authorStackView.addGestureRecognizer(tapAuthor)
        if likeCount == 0 {
            likeLabel.text = "還沒有人點讚"
        } else {
        likeLabel.text = "\(likeCount) 個讚"
        }
        if likeCount == 0 {
            commentsLabel.text = "目前沒有留言"
        } else {
            commentsLabel.text = "查看全部\(likeCount) 則留言"
        }
        if isLogin {
            if isLike {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            if isFollow {
                followButton.setTitle("已追蹤", for: .normal)
            } else {
                followButton.setTitle("追蹤", for: .normal)
            }
        } else {
            followButton.setTitle("追蹤", for: .normal)
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    @objc private func doubleTap() {
        self.delegate?.didtapLike(self, targetComment: commentData)
    }
    
    @objc private func tapAuthorView() {
        self.delegate?.didtapAuthor(self, targetUserID: targetUserID)
    }
}
