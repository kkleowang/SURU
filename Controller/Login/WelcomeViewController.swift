//
//  WelcomeViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit
import WebKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class WelcomeViewController: UIViewController {
    weak var delegate: SignInAndOutViewControllerDelegate?
    private let welcomeView: WelcomeView = .fromNib()
    fileprivate var currentNonce: String?
    var webView = WKWebView() {
        didSet {
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWelcomView()
    }
    private func setupWelcomView() {
        if #available(iOS 13.2, *) {
            welcomeView.setAppleButton()
        } else {
            // Fallback on earlier versions
        }
        welcomeView.delegate = self
        view.stickSubView(welcomeView)
    }
    private func initSignView(state: SignPageState) {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "SignInAndOutViewController") as? SignInAndOutViewController else { return }
        controller.delegate = self.delegate
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
    func didTapAppleButton(_ view: WelcomeView) {
        startSignInWithAppleFlow()
    }
    
    func didTapPrivacyLabel(_ view: WelcomeView) {
        let controller = WebView()
        controller.url = "https://www.privacypolicies.com/live/2dbb6a88-d041-40f9-ae5b-d1385b4f9b97"
        present(controller, animated: true)
    }
    
    func didTapEulaLabel(_ view: WelcomeView) {
        let controller = WebView()
        controller.url = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
        present(controller, animated: true)
    }
    
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
extension WelcomeViewController {
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
@available(iOS 13.0, *)
extension WelcomeViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            var name = "新訪客"
            if let fullName = appleIDCredential.fullName {
                if let givenName = fullName.givenName, let familyName = fullName.familyName {
                    name = "\(givenName) \(familyName)"
                }
            }
            // Initialize a Firebase credential.
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            UserRequestProvider.shared.appleLogin(credential: credential,name: name) { result in
                switch result {
                case .failure(let error):
                    print("apple登入失敗", error)
                    LKProgressHUD.showFailure(text: "登入失敗")
                case .success(let message):
                    LKProgressHUD.showSuccess(text: message)
                    print("apple登入成功", message)
                    self.dismiss(animated: true)
                }
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
}
