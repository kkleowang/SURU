//
//  LoginView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import AuthenticationServices
import UIKit

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
    @IBOutlet var appleButtonView: UIView!
    @IBOutlet var appLogoImage: UIImageView!
    @IBOutlet var appWelcomeLabel: UILabel!

    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!

    @IBOutlet var visitAsGuestButton: UIButton!
    @IBOutlet var privacyButton: UIButton!
    @IBOutlet var eulaButton: UIButton!
    @IBAction func signUp(_: UIButton) {
        delegate?.didTapSignUp(self)
    }

    @IBAction func logIn(_: UIButton) {
        delegate?.didTapLogIn(self)
    }

    @IBAction func visetAsGuest(_: UIButton) {
        delegate?.didTapVisetAsGuest(self)
    }

    @IBAction func tapEula(_: Any) {
        delegate?.didTapEulaLabel(self)
    }

    @IBAction func tapPrivacy(_: Any) {
        delegate?.didTapPrivacyLabel(self)
    }

    @available(iOS 13.2, *)
    func setAppleButton() {
        let appleButton = ASAuthorizationAppleIDButton(type: .signUp, style: .black)
        appleButton.addTarget(self, action: #selector(tapAppleButton), for: .touchUpInside)
        appleButtonView.stickSubView(appleButton)
    }

    @objc private func tapAppleButton() {
        delegate?.didTapAppleButton(self)
    }
}
