//
//  ProfileView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit

protocol ProfileViewDelegate: AnyObject {
    func didTapLogoutButton(view: ProfileView)
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
        self.delegate?.didTapLogoutButton(view: self)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
