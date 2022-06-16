//
//  DiscoveryCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/1.
//

import Kingfisher
import UIKit

protocol DiscoveryCellDelegate: AnyObject {
    func didTapLikeButton(_ view: DiscoveryCell, comment: Comment)

    func didTapUnLikeButton(_ view: DiscoveryCell, comment: Comment)

    func didTapCommentBtn(_ view: DiscoveryCell, comment: Comment)
}

class DiscoveryCell: UICollectionViewCell {
    weak var delegate: DiscoveryCellDelegate?
    var commentHolder: Comment?

    @IBOutlet var mainImageView: UIImageView!

    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var mealLabel: UILabel!

    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var authorNameLabel: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var commentButton: UIButton!

    @IBAction func tapCommentBtn(_: Any) {
        guard let commentHolder = commentHolder else { return }
        delegate?.didTapCommentBtn(self, comment: commentHolder)
    }

    @IBAction func tapLikeButton(_ sender: UIButton) {
        guard let commentHolder = commentHolder else { return }
        guard let image = sender.imageView?.image else { return }
        if image == UIImage(systemName: "heart.fill") {
            delegate?.didTapUnLikeButton(self, comment: commentHolder)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.setTitle("\((Int(likeButton.currentTitle ?? "1") ?? 1) - 1)", for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.setTitle("\((Int(likeButton.currentTitle ?? "0") ?? 0) + 1)", for: .normal)
            delegate?.didTapLikeButton(self, comment: commentHolder)
        }
    }

    func layoutCell(author: Account, comment: Comment, currentUser: Account, store: Store) {
        mainImageView.cornerRadii(radii: 10)
        authorImageView.addCircle(color: UIColor.white.cgColor, borderWidth: 1)
        commentHolder = comment
        mainImageView.kf.setImage(with: URL(string: comment.mainImage))
        
        nameLabel.text = "\(store.name)"
        mealLabel.font = .medium(size: 14)
        authorNameLabel.font = .medium(size: 14)
        mealLabel.text = comment.meal
        
        authorNameLabel.adjustsFontSizeToFitWidth = true
        authorImageView.loadImage(author.mainImage, placeHolder: UIImage(named: "mainImage"))
        authorNameLabel.text = author.name

        if currentUser.likedComment.contains(comment.commentID) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }

        if !comment.likedUserList.isEmpty {
            likeButton.setTitle(String(comment.likedUserList.count), for: .normal)
        } else {
            likeButton.setTitle("", for: .normal)
        }

        let messages = comment.userComment ?? []

        if !messages.isEmpty {
            commentButton.setTitle(String(messages.count), for: .normal)
        } else {
            commentButton.setTitle("", for: .normal)
        }

        if author.badgeStatus != nil {
            //            badgeImageView.image = UIImage(named: "\(author.badgeStatus!)")
        }
    }
}
