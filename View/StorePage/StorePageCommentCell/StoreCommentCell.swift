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
        loginStatus = isLogin
        likeStatus = isLike
        followStatus = isFollow
        
        authorImageView.layer.cornerRadius = authorImageView.bounds.width / 2
        authorImageView.layer.borderWidth = 1.0
        authorImageView.layer.borderColor = UIColor.white.cgColor
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.kf.setImage(with: URL(string: author.mainImage), placeholder: UIImage(named: "AppIcon"))
        
        authorNameLabel.text = author.name
        authorFollowerLabel.text = "\(author.follower.count) 人追蹤中"
        
        commentImageView.kf.setImage(with: URL(string: comment.mainImage), placeholder: UIImage(named: "AppIcon"))
        commentImageView.addGestureRecognizer(doubleTapImage)
        commentImageView.isUserInteractionEnabled = true
        let likeCount = comment.likedUserList.count
        likeLabel.text = "\(likeCount) 個喜歡"
        if likeCount == 0 {
            commentsLabel.text = "目前沒有留言"
        } else {
            commentsLabel.text = "查看全部\(likeCount) 則留言"
        }
        if isLogin {
            if isLike {
                likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
            } else {
                likeButton.setImage(UIImage(named: "heart"), for: .normal)
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
    let doubleTapImage = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
    @objc private func doubleTap() {
        self.delegate?.didtapLike(self, targetComment: commentData)
    }
    let tapAuthor = UITapGestureRecognizer(target: self, action: #selector(tapAuthorView))
    @objc private func tapAuthorView() {
        self.delegate?.didtapAuthor(self, targetUserID: targetUserID)
    }
}
