//
//  ProfileHeaderCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/15.
//

import UIKit
protocol ProfileHeaderCellDelegate: AnyObject {
    func didtapBackBtn(_ view: ProfileHeaderCell)
    func didtapBadgeBtn(_ view: ProfileHeaderCell)
    func didtapSettingBtn(_ view: ProfileHeaderCell, targetUserID: String?)
    //    func didtapBlockBtn(_ view:  ProfileHeaderCell)

    func didtapPost(_ view: ProfileHeaderCell)
    func didtapFans(_ view: ProfileHeaderCell)
    func didtapFollower(_ view: ProfileHeaderCell)
}

class ProfileHeaderCell: UITableViewHeaderFooterView {
    weak var delegate: ProfileHeaderCellDelegate?
    var accountID: String?

    @IBAction func tapBackBtn(_: Any) {
        delegate?.didtapBackBtn(self)
    }

    @IBAction func tapBadgeBtn(_: Any) {
        delegate?.didtapBadgeBtn(self)
    }

    @IBAction func tapSettingBtn(_: Any) {
        delegate?.didtapSettingBtn(self, targetUserID: accountID)
    }

    @objc func tapPost() {
        delegate?.didtapPost(self)
    }

    @objc func tapFans() {
        delegate?.didtapFans(self)
    }

    @objc func tapFollower() {
        delegate?.didtapFollower(self)
    }

    @IBOutlet var bgImageView: UIImageView!

    @IBOutlet var backBtn: UIButton!
    @IBOutlet var badgeBtv: UIButton!
    @IBOutlet var settingBtn: UIButton!

    @IBOutlet var accountImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var badgeImageView: UIImageView!

    @IBOutlet var postLabel: UILabel!
    @IBOutlet var followerLabel: UILabel!
    @IBOutlet var followedLabel: UILabel!

    @IBOutlet var postLabelView: UIStackView!
    @IBOutlet var followerLabelView: UIStackView!
    @IBOutlet var followedLabelView: UIStackView!

    // Icons_24px_ListView
    func layoutHeaderCell(isOnPush: Bool, isCurrenAccount: Bool, account: Account) {
        if !isOnPush {
            backBtn.isHidden = true
        }
        if isCurrenAccount {
            settingBtn.setImage(UIImage(named: "Icons_24px_ListView"), for: .normal)
        } else {
            settingBtn.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        }
        if let badge = account.badgeStatus {
            badgeImageView.image = UIImage(named: badge)
        } else {
            badgeImageView.isHidden = true
        }
        postLabelView.isUserInteractionEnabled = true
        followerLabelView.isUserInteractionEnabled = true
        followedLabelView.isUserInteractionEnabled = true
        let tapPost = UITapGestureRecognizer(target: self, action: #selector(tapPost))
        let tapFans = UITapGestureRecognizer(target: self, action: #selector(tapFans))
        let tapFollower = UITapGestureRecognizer(target: self, action: #selector(tapFollower))
        postLabelView.addGestureRecognizer(tapPost)
        followerLabelView.addGestureRecognizer(tapFans)
        followedLabelView.addGestureRecognizer(tapFollower)

        accountImageView.loadImage(account.mainImage, placeHolder: UIImage(named: "mainImage"))
        accountImageView.layer.cornerRadius = 90 / 2
        accountImageView.layer.borderWidth = 2.0
        accountImageView.layer.borderColor = UIColor.white.cgColor
        accountImageView.contentMode = .scaleAspectFill
        accountImageView.clipsToBounds = true

        nameLabel.text = account.name

        postLabel.text = "\(account.commentCount)"
        followerLabel.text = "\(account.follower.count)"
        followedLabel.text = "\(account.followedUser.count)"
    }
}
