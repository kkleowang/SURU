//
//  LoginView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit
import AuthenticationServices

protocol WelcomeViewDelegate: AnyObject {
    func didTapSignUp(_ view: WelcomeView)
    func didTapLogIn(_ view: WelcomeView)
    func didTapVisetAsGuest(_ view: WelcomeView)
    func didTapPrivacyLabel(_ view: WelcomeView)
    func didTapEulaLabel(_ view: WelcomeView)
    func didTapAppleButton(_ view: WelcomeView)
}

class WelcomeView: UIView {
    weak var delegate: WelcomeViewDelegate?
    @IBOutlet weak var appleButtonView: UIView!
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var appWelcomeLabel: UILabel!
    
     @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var visitAsGuestButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var eulaButton: UIButton!
    @IBAction func signUp(_ sender: UIButton) {
        self.delegate?.didTapSignUp(self)
    }
    @IBAction func logIn(_ sender: UIButton) {
        self.delegate?.didTapLogIn(self)
    }
    @IBAction func visetAsGuest(_ sender: UIButton) {
        self.delegate?.didTapVisetAsGuest(self)
    }
    @IBAction func tapEula(_ sender: Any) {
        self.delegate?.didTapEulaLabel(self)
    }
    
    @IBAction func tapPrivacy(_ sender: Any) {
        self.delegate?.didTapPrivacyLabel(self)
    }
    
    @available(iOS 13.2, *)
    func setAppleButton() {
        let appleButton = ASAuthorizationAppleIDButton(type: .signUp, style: .black)
        appleButton.addTarget(self, action: #selector(tapAppleButton), for:  .touchUpInside)
        appleButtonView.stickSubView(appleButton)
    }
    
    @objc private func tapAppleButton() {
        self.delegate?.didTapAppleButton(self)
    }
}
