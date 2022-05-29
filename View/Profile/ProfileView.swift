//
//  ProfileView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import Kingfisher
import UIKit

protocol ProfileViewDelegate: AnyObject {
    func didTapAccountButton(_ view: ProfileView)
    func didTapEditProfilebutton(_ view: ProfileView)
    func didTapBadge(_ view: ProfileView)
}

class ProfileView: UIView {
    weak var delegate: ProfileViewDelegate?

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var badgeImageView: UIImageView!

    @IBAction func tapEditProfilebutton(_: UIButton) {
        delegate?.didTapEditProfilebutton(self)
    }

    @IBOutlet var tapAccountButton: UIButton!
    @IBAction func tapAccountButton(_: Any) {
        delegate?.didTapAccountButton(self)
    }

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var follwersCountLabel: UILabel!
    @IBOutlet var follwingCountLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    var webLink = URL(string: "")
    @objc func linkWeb() {
        guard let webLink = webLink else { return }
        UIApplication.shared.open(webLink)
    }

    func layoutView(account: Account) {
        let web = account.websideLink ?? ""
        webLikeImageView.tintColor = .B1
        if !web.isEmpty {
            webLink = URL(string: web)
            let tap = UITapGestureRecognizer(target: self, action: #selector(linkWeb))
            webLikeImageView.addGestureRecognizer(tap)
            webLikeImageView.isUserInteractionEnabled = true
            webLikeImageView.isHidden = false
        } else {
            webLikeImageView.isHidden = true
        }
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = UIColor.B6?.cgColor
        editProfileButton.layer.cornerRadius = 15
        editProfileButton.clipsToBounds = true
        mainImageView.layer.cornerRadius = 40
        mainImageView.clipsToBounds = true
        mainImageView.kf.setImage(with: URL(string: account.mainImage))
        follwersCountLabel.text = String(account.follower.count)
        follwingCountLabel.text = String(account.followedUser.count)
        nameLabel.text = account.name
        bioLabel.text = account.bio
        let badge = account.badgeStatus ?? ""
        if badge.isEmpty {
            badgeImageView.isHidden = true
        } else {
            badgeImageView.image = UIImage(named: "long_\(badge)")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(initBadge))
        badgeImageView.isUserInteractionEnabled = true
        badgeImageView.addGestureRecognizer(tap)
    }

    @objc func initBadge() {
        delegate?.didTapBadge(self)
    }

    @IBOutlet var webLikeImageView: UIImageView!
}
