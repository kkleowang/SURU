//
//  DiscoveryCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/1.
//

import UIKit
import Kingfisher

protocol DiscoveryCellDelegate: AnyObject {
    func didTapLikeButton(_ view: DiscoveryCell, comment: Comment)
    
    func didTapUnLikeButton(_ view: DiscoveryCell, comment: Comment)
    
    func didTapCommentBtn(_ view: DiscoveryCell, comment: Comment)
    
}

class DiscoveryCell: UICollectionViewCell {
    weak var delegate: DiscoveryCellDelegate?
    var commentHolder: Comment?
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mealLabel: UILabel!
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
//    @IBOutlet weak var badgeImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBAction func tapCommentBtn(_ sender: Any) {
        guard let commentHolder = commentHolder else { return }
        self.delegate?.didTapCommentBtn(self, comment: commentHolder)
    }
    @IBAction func tapLikeButton(_ sender: UIButton) {
        guard let commentHolder = commentHolder else { return }
        guard let image = sender.imageView?.image else { return }
        if image == UIImage(systemName: "heart.fill") {
            self.delegate?.didTapUnLikeButton(self, comment: commentHolder)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.setTitle("\((Int(likeButton.currentTitle ?? "1") ?? 1 ) - 1)", for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.setTitle("\((Int(likeButton.currentTitle ?? "0") ?? 0 ) + 1 )", for: .normal)
            self.delegate?.didTapLikeButton(self, comment: commentHolder)
        }
        
    }
    
    
    func layoutCell(author: Account, comment: Comment, currentUser: Account, store: Store) {
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 10
        authorImageView.addCircle(color: UIColor.white.cgColor, borderWidth: 1)
        commentHolder = comment
        mainImageView.kf.setImage(with: URL(string: comment.mainImage))
            
        nameLabel.text = "\(store.name)"
//        nameLabel.font = .medium(size: 16)
        mealLabel.font = .medium(size: 14)
        authorNameLabel.font = .medium(size: 14)
        mealLabel.text = comment.meal
//        nameLabel.adjustsFontSizeToFitWidth = true
//        mealLabel.adjustsFontSizeToFitWidth = true
        authorNameLabel.adjustsFontSizeToFitWidth = true
            authorImageView.loadImage(author.mainImage , placeHolder: UIImage(named: "mainImage"))
            authorNameLabel.text = author.name
        
        if currentUser.likedComment.contains(comment.commentID) {
           likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
       } else {
           likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
       }
        
        if comment.likedUserList.count != 0 {
            likeButton.setTitle(String(comment.likedUserList.count), for: .normal)
           
        } else {
            likeButton.setTitle("", for: .normal)
        }

        let count = comment.userComment?.count ?? 0
        
        if count != 0 {
            commentButton.setTitle(String(count), for: .normal)
        } else {
            commentButton.setTitle("", for: .normal)
        }
      
        if author.badgeStatus != nil {
            
//            badgeImageView.image = UIImage(named: "\(author.badgeStatus!)")
        }
     
//        self.layer.borderWidth = 3
//        guard let badgeColor = author.badgeStatus else {
//            self.layer.borderColor = UIColor.B5?.cgColor
//            return
//        }
//        switch badgeColor.last?.wholeNumberValue! {
//        case 1:
//            self.layer.borderColor = UIColor.brown.cgColor
//        case 2:
//            self.layer.borderColor = UIColor.purple.cgColor
//        case 3:
//            self.layer.borderColor = UIColor.systemBlue.cgColor
//        case 4:
//            self.layer.borderColor = UIColor.systemPurple.cgColor
//        case 5:
//            self.layer.borderColor = UIColor.systemOrange.cgColor
//        default:
//            self.layer.borderColor = UIColor.B5?.cgColor
//        }
    }
    
    
}
