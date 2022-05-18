//
//  SignInAndOutView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import Foundation
import UIKit

protocol SignInAndOutViewDelegate: AnyObject {
    func didTapSendButton(_ view: UIView, email: String, password: String)
   
    func didGotWrongInput(_ view: UIView, message: String)
    
    
}

class SignInAndOutView: UIView {
    weak var delegate: SignInAndOutViewDelegate?
    var status: SignPageState?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBAction func tapSendButton(_ sender: UIButton) {
        guard let status = status else { return }
        
        guard let email = emailTextField.text else {
            self.delegate?.didGotWrongInput(self, message: "請輸入Email。")
            return
        }
        guard let password = passwordTextField.text else {
            self.delegate?.didGotWrongInput(self, message: "請輸入密碼。")
            return
        }
        guard let passwordCheck = passwordCheckTextField.text else {
            self.delegate?.didGotWrongInput(self, message: "請再次輸入你的密碼。")
            return
        }
        
        
        if status == .sighUp {
            if !isValidEmail(email) {
                self.delegate?.didGotWrongInput(self, message: "請輸入正確的Email。")
                emailTextField.textColor = .red
                return
            }
            if password.count < 6 {
                
                self.delegate?.didGotWrongInput(self, message: "密碼最少需要六個字以上。")
                passwordTextField.textColor = .red
                return
            }
            if password != passwordCheck {
                self.delegate?.didGotWrongInput(self, message: "密碼不一致。")
                passwordCheckTextField.textColor = .red
                return
            } else {
                if !isValidEmail(email) {
                    self.delegate?.didGotWrongInput(self, message: "Email無效。")
                    emailTextField.textColor = .red
                    return
                }
                if password.count < 6 {
                    self.delegate?.didGotWrongInput(self, message: "密碼最少需要六個字以上喔！")
                    passwordTextField.textColor = .red
                    return
                }
            }
        }
        self.delegate?.didTapSendButton(self, email: email, password: password)
    }
    @IBAction func tapForgotButton(_ sender: UIButton) {
    }
    func layoutSignInPage() {
        status = .signIn
        forgotPasswordButton.isHidden = true
        passwordCheckTextField.isHidden = true
        sendButton.setTitle("登入", for: .normal)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    func layoutSignUpPage() {
        status = .sighUp
        forgotPasswordButton.isHidden = true
        forgotPasswordButton.isHidden = true
        sendButton.setTitle("註冊", for: .normal)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        passwordCheckTextField.isEnabled = false
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
extension SignInAndOutView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            passwordCheckTextField.isEnabled = true
        }
        textField.textColor = .B1
    }
}
