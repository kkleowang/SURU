//
//  LoginViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/26.
//

import Foundation
import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

enum SignPageState {
    case sighUp
    case signIn
}
class SignInAndOutViewController: UIViewController {
    fileprivate var currentNonce: String?
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

// login function
extension SignInAndOutViewController {
    
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
extension SignInAndOutViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
          print(error)
          return
        }
          if let user = authResult?.user {
              print("Login success ID as Doc ID is ", user.uid, user.email)
          }
      }
    }
  }
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
extension SignInAndOutViewController: SignInAndOutViewDelegate {
    func didTapSendButton(_ view: UIView, email: String, password: String) {
        guard let state = pageState else { return }
        switch state {
        case .sighUp:
            UserRequestProvider.shared.nativeSignUp(withEmail: email, withPassword: password)
        case .signIn:
            UserRequestProvider.shared.nativeLogIn(withEmail: email, withPassword: password)
        }
    }
    
    func didTapAppleButton(_ view: UIView) {
        startSignInWithAppleFlow()
    }
    
    func didTapForgotPasswordButton(_ view: UIView) {
        print("ForgotPassword")
    }
    
    
   
    
}
