//
//  WelcomeViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit


class WelcomeViewController: UIViewController {
    private let welcomeView: WelcomeView = .fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWelcomView()
    }
    private func setupWelcomView() {
        welcomeView.delegate = self
        view.stickSubView(welcomeView)
    }
    private func initSignView(state: SignPageState) {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "SignInAndOutViewController") as? SignInAndOutViewController else { return }
        controller.pageState = state
        controller.layoutSignView()
        if #available(iOS 15.0, *) {
            if let sheet = controller.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 20
            }
        }
        present(controller, animated: true, completion: nil)
    }
}

extension WelcomeViewController: WelcomeViewDelegate {
    func didTapSignUp(_ view: WelcomeView) {
        initSignView(state: .sighUp)
    }
    func didTapLogIn(_ view: WelcomeView) {
        initSignView(state: .signIn)
    }
    func didTapVisetAsGuest(_ view: WelcomeView) {
        dismiss(animated: true, completion: nil)
    }
}
