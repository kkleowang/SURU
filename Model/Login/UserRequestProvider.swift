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
    lazy var firebaseAuth = Auth.auth()
    
    func nativeSignIn(withEmail email: String, withPassword password: String) {
        firebaseAuth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          // ...
        }
    }
    
    func nativeSignUp(withEmail email: String, withPassword password: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let user = authResult?.user else { return }
            var account = self.mappingNativeUser(user: user)
            AccountRequestProvider.shared.publishRegistedAccount(account: &account) { result in
                switch result {
                case .success(let string):
                    completion(.success(string))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
        }
    }
    func mappingNativeUser(user: User) -> Account {
        let account = Account(userID: user.uid, provider: user.providerID)
        return account
    }
//    func mappingAppleUser(user: User) -> Account {
//        let account = Account(
//    }
    
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
