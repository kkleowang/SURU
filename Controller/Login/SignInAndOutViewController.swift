//
//  LoginViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/26.
//

import Foundation
import UIKit

protocol SignInAndOutViewControllerDelegate: AnyObject {
    func didSelectGoEditProfile(_ view: SignInAndOutViewController)
    func didSelectLookAround(_ view: SignInAndOutViewController)
}
enum SignPageState {
    case sighUp
    case signIn
}
class SignInAndOutViewController: UIViewController {
    weak var delegate: SignInAndOutViewControllerDelegate?
    var pageState: SignPageState?
    let signInAndOutView: SignInAndOutView = .fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.stickSubView(signInAndOutView)
        signInAndOutView.delegate = self
    }
    func layoutSignView() {
        guard let state = pageState else { return }
        switch state {
        case .sighUp:
            signInAndOutView.layoutSignUpPage()
        case .signIn:
            signInAndOutView.layoutSignInPage()
        }
    }
}

extension SignInAndOutViewController: SignInAndOutViewDelegate {
    func didGotWrongInput(_ view: UIView, message: String) {
        let alert = UIAlertController(title: "登入提示", message: message, preferredStyle: .alert)
        let notify = UIAlertAction(title: "好", style: .default)
        alert.addAction(notify)
        present(alert, animated: true, completion: nil)
    }
    
    func didTapSendButton(_ view: UIView, email: String, password: String) {
        guard let state = pageState else { return }
        switch state {
        case .sighUp:
            signUP(email: email, password: password)
        case .signIn:
            signIn(email: email, password: password)
        }
    }
    func signUP(email: String, password: String) {
        UserRequestProvider.shared.nativeSignUp(withEmail: email, withPassword: password) { result in
            switch result {
            case .failure(let error):
                LKProgressHUD.showFailure(text: "登入失敗請再試一次")
            case .success(let message):
                self.showAddInfoAlert()
                LKProgressHUD.showSuccess(text: message)
            }
        }
    }
    
    func signIn(email: String, password: String) {
        UserRequestProvider.shared.nativeSignIn(withEmail: email, withPassword: password) { result in
            switch result {
            case .failure(let error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            case .success(let message):
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                LKProgressHUD.showSuccess(text: message)
            }
        }
    }
    
    func showAddInfoAlert() {
        let alert = UIAlertController(title: "提示", message: "現在就去編輯自己的個人資料嗎", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .default) { _ in
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            self.delegate?.didSelectGoEditProfile(self)
        }
        let cancelAction = UIAlertAction(title: "先去逛逛", style: .cancel) { _ in
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            self.delegate?.didSelectLookAround(self)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func initInfoView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "SignInAndOutViewController") as? SignInAndOutViewController else { return }
        controller.layoutSignView()
        if #available(iOS 15.0, *) {
            if let sheet = controller.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 20
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
}
