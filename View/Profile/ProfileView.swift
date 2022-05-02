//
//  ProfileView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit

protocol ProfileViewDelegate: AnyObject {
    func didTapLogoutButton(_ view: ProfileView)
    func didTapDeleteButton(_ view: ProfileView)
}

class ProfileView: UIView {

    weak var delegate: ProfileViewDelegate?
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var follwersCountLabel: UILabel!
    @IBOutlet weak var follwingCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var logoutLabel: UIButton!
    
    @IBAction func logout(_ sender: UIButton) {
        self.delegate?.didTapLogoutButton(self)
    }
    @IBAction func deleteAccount(_ sender: UIButton) {
        self.delegate?.didTapDeleteButton(self)
    }

}
