//
//  ProfileViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit

class ProfileViewController: UIViewController {

    let profileView: ProfileView = UIView.fromNib()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.stickSubView(profileView)
        profileView.delegate = self
        
    }
    
}
extension ProfileViewController: ProfileViewDelegate {
    func didTapLogoutButton(view: ProfileView) {
        UserRequestProvider.shared.logOut()
    }
}
