//
//  StoreCommentCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/11.
//

import Kingfisher
import Lottie
import UIKit

protocol StoreCommentCellDelegate: AnyObject {
    func didtapLike(_ view: StoreCommentCell, targetComment: Comment?, isLogin: Bool, isLike: Bool)
    func didtapfollow(_ view: StoreCommentCell, targetUserID: String?, isLogin: Bool, isFollow: Bool)
    func didtapMore(_ view: StoreCommentCell, targetUserID: String?, isLogin: Bool)
    func didtapAuthor(_ view: StoreCommentCell, targetUserID: String?)
}

class StoreCommentCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    weak var delegate: StoreCommentCellDelegate?
    var targetUserID: String?
    var commentData: Comment?

    var isloginStatus = false
    var islikeStatus = false
    var isfollowStatus = false

    @IBAction func tapLike(_: Any) {
        delegate?.didtapLike(self, targetComment: commentData, isLogin: isloginStatus, isLike: islikeStatus)

        if islikeStatus {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }

    @IBAction func tapFollow(_: Any) {
        delegate?.didtapfollow(self, targetUserID: targetUserID, isLogin: isloginStatus, isFollow: isfollowStatus)

        if isfollowStatus {
            followButton.setTitle("追蹤", for: .normal)
        } else {
            followButton.setTitle("已追蹤", for: .normal)
        }
    }

    @IBAction func tapMore(_: Any) {
        delegate?.didtapMore(self, targetUserID: targetUserID, isLogin: isloginStatus)
    }

    @objc private func doubleTap() {
        delegate?.didtapLike(self, targetComment: commentData, isLogin: isloginStatus, isLike: islikeStatus)

        if islikeStatus {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }

    @objc private func tapAuthorView() {
        delegate?.didtapAuthor(self, targetUserID: targetUserID)
    }

    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var authorFollowerLabel: UILabel!
    @IBOutlet var authorStackView: UIStackView!

    @IBOutlet var likeButton: UIButton!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var moreButton: UIButton!

    @IBOutlet var commentImageView: UIImageView!

    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!

    func layoutView(author: Account, comment: Comment, isFollow: Bool, isLike: Bool) {
        selectionStyle = .none
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.B1?.cgColor

        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        islikeStatus = isLike
        isfollowStatus = isFollow
        commentData = comment
        targetUserID = comment.userID
        authorImageView.addCircle(color: UIColor.white.cgColor, borderWidth: 1)

        authorImageView.kf.setImage(with: URL(string: author.mainImage), placeholder: UIImage(named: "mainImage"))

        authorNameLabel.text = author.name
        authorFollowerLabel.text = "\(author.follower.count) 人追蹤中"
        commentImageView.cornerForAll(radii: 10)
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
            likeLabel.text = "\(likeCount) 個喜歡"
        }

        if message.isEmpty {
            commentsLabel.text = "目前沒有留言"
        } else {
            commentsLabel.text = "查看全部\(message.count) 則留言"
        }
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
    }
}
