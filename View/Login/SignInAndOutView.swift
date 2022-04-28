//
//  SignInAndOutView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import Foundation
import UIKit
import AuthenticationServices

protocol SignInAndOutViewDelegate: AnyObject {
    func didTapSendButton(_ view: UIView, email: String, password: String)
    func didTapAppleButton(_ view: UIView)
    func didTapForgotPasswordButton(_ view: UIView)
}

class SignInAndOutView: UIView {
    
    weak var delegate: SignInAndOutViewDelegate?
    
    @IBOutlet weak var appleButton: ASAuthorizationAppleIDButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBAction func tapSendButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        self.delegate?.didTapSendButton(self, email: email, password: password)
    }
    @IBAction func tapForgotButton(_ sender: UIButton) {
        self.delegate?.didTapForgotPasswordButton(self)
    }
    func layoutSignInPage() {
        passwordCheckTextField.isHidden = true
        sendButton.setTitle("登入", for: .normal)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isEnabled = false
        
        appleButton.addTarget(self, action: #selector(tapAppleButton), for: .touchUpInside)
        
    }
    func layoutSignUpPage() {
        forgotPasswordButton.isHidden = true
        sendButton.setTitle("註冊", for: .normal)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        passwordTextField.isEnabled = false
        passwordCheckTextField.isEnabled = false
        
        appleButton.addTarget(self, action: #selector(tapAppleButton), for: .touchUpInside)
        
    }
    
    
    
    @objc private func tapAppleButton() {
        self.delegate?.didTapAppleButton(self)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
extension SignInAndOutView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            guard let email = textField.text else { return }
            if isValidEmail(email) {
                passwordTextField.isEnabled = true
                emailTextField.textColor = .black
            } else {
                emailTextField.textColor = .red
            }
        } else if textField == passwordTextField {
            guard let password = textField.text else { return }
            if password.count >= 6 {
                passwordTextField.textColor = .black
                if sendButton.currentTitle == "註冊" {
                    passwordCheckTextField.isEnabled = true
                } else {
                    sendButton.isEnabled = true
                }
            } else {
                sendButton.isEnabled = false
                passwordTextField.textColor = .red
            }
        } else if textField == passwordCheckTextField {
            guard let passwordCheck = textField.text else { return }
            guard let password = passwordTextField.text else { return }
            if password == passwordCheck {
                passwordCheckTextField.textColor = .black
                sendButton.isEnabled = true
            } else {
                passwordCheckTextField.textColor = .red
                sendButton.isEnabled = false
            }
        }
    }
}
