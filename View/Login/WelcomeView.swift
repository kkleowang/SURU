//
//  LoginView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit

protocol WelcomeViewDelegate: AnyObject {
    func didTapSignUp(_ view: WelcomeView)
    func didTapLogIn(_ view: WelcomeView)
    func didTapVisetAsGuest(_ view: WelcomeView)
}

class WelcomeView: UIView {

    weak var delegate: WelcomeViewDelegate?
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var appWelcomeLabel: UILabel!
    
     @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var visitAsGuestButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func signUp(_ sender: UIButton) {
        self.delegate?.didTapSignUp(self)
    }
    @IBAction func logIn(_ sender: UIButton) {
        self.delegate?.didTapLogIn(self)
    }
    @IBAction func visetAsGuest(_ sender: UIButton) {
        self.delegate?.didTapVisetAsGuest(self)
    }
    
}
