//
//  StoreCommentCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/11.
//

import UIKit
import Kingfisher

protocol StoreCommentCellDelegate: AnyObject {
    func didtapLike(_ view: StoreCommentCell, targetComment: Comment?, isLogin: Bool, isLike: Bool)
    func didtapfollow(_ view: StoreCommentCell, targetUserID: String?, isLogin: Bool, isFollow: Bool)
    func didtapMore(_ view: StoreCommentCell, targetUserID: String?, isLogin: Bool)
    func didtapAuthor(_ view: StoreCommentCell, targetUserID: String?)
}

class StoreCommentCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
//
//        contentView.layer.cornerRadius = 15
//        contentView.clipsToBounds = true
//        contentView.backgroundColor = .blue
    }
    weak var delegate: StoreCommentCellDelegate?
    var targetUserID: String?
    var commentData: Comment?
    
    var isloginStatus = false
    var islikeStatus = false
    var isfollowStatus = false
    
    @IBAction func tapLike(_ sender: Any) {
        self.delegate?.didtapLike(self, targetComment: commentData, isLogin: isloginStatus, isLike: islikeStatus)
        if isloginStatus {
            if islikeStatus {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
    @IBAction func tapFollow(_ sender: Any) {
        
        self.delegate?.didtapfollow(self, targetUserID: targetUserID, isLogin: isloginStatus, isFollow: isfollowStatus)
        
        if isloginStatus {
            if isfollowStatus {
                followButton.setTitle("追蹤", for: .normal)
            } else {
                followButton.setTitle("已追蹤", for: .normal)
            }
        }
    }
    @IBAction func tapMore(_ sender: Any) {
        self.delegate?.didtapMore(self, targetUserID: targetUserID, isLogin: isloginStatus)
    }
    @objc private func doubleTap() {
        self.delegate?.didtapLike(self, targetComment: commentData, isLogin: isloginStatus, isLike: islikeStatus)
        if isloginStatus {
            if islikeStatus {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
    
    @objc private func tapAuthorView() {
        self.delegate?.didtapAuthor(self, targetUserID: targetUserID)
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
        followButton.layer.cornerRadius = 10
        followButton.clipsToBounds = true
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.B1?.cgColor
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        isloginStatus = isLogin
        islikeStatus = isLike
        isfollowStatus = isFollow
        commentData = comment
        targetUserID = comment.userID
        
        authorImageView.layer.cornerRadius = authorImageView.bounds.width / 2
        authorImageView.layer.borderWidth = 1.0
        authorImageView.layer.borderColor = UIColor.white.cgColor
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.kf.setImage(with: URL(string: author.mainImage), placeholder: UIImage(named: "mainImage"))
        
        authorNameLabel.text = author.name
        authorFollowerLabel.text = "\(author.follower.count) 人追蹤中"
        
        commentImageView.kf.setImage(with: URL(string: comment.mainImage), placeholder: UIImage(named: "mainImage"))
        let tapAuthor = UITapGestureRecognizer(target: self, action: #selector(tapAuthorView))
        let doubleTapImage = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        commentImageView.addGestureRecognizer(doubleTapImage)
        doubleTapImage.numberOfTapsRequired = 2
        commentImageView.isUserInteractionEnabled = true
        let likeCount = comment.likedUserList.count
        let message = comment.userComment ?? []
        authorStackView.isUserInteractionEnabled = true
        authorStackView.addGestureRecognizer(tapAuthor)
        if likeCount == 0 {
            likeLabel.text = "還沒有人點讚"
        } else {
        likeLabel.text = "\(likeCount) 個讚"
        }
        
        if message.isEmpty {
            commentsLabel.text = "目前沒有留言"
        } else {
            commentsLabel.text = "查看全部\(message.count) 則留言"
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
}
