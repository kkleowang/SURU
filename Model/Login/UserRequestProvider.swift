//
//  UserProvider.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/26.
//

import Foundation
import FirebaseAuth

class UserRequestProvider {
    
    static let shared = UserRequestProvider()
    // Native
    private lazy var firebaseAuth = Auth.auth()
    
    func nativeSignUp(withEmail email: String, withPassword password: String) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
          // ...
        }
    }
    
    func nativeLogIn(withEmail email: String, withPassword password: String) {
        firebaseAuth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          // ...
        }
    }
    
    func logOut() {
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func nativeDeleteAccount() {
        let user = firebaseAuth.currentUser
        user?.delete(completion: { error in
            if let error = error {
                print("nativeDeleteAccount", error)
            } else {
                print("nativeDeleteAccount", "Success")
            }
        })
    }
    
    

}
