//
//  UserProvider.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/26.
//

import FirebaseAuth
import Foundation

// auth
class UserRequestProvider {
    static let shared = UserRequestProvider()
    var currentUser: User? {
        firebaseAuth.currentUser
    }
    lazy var firebaseAuth = Auth.auth()
    var currentUserID: String? {
        firebaseAuth.currentUser?.uid
    }



//    func listenFirebaseLogin(completion: @escaping (String?) -> Void) {
//        firebaseAuth.addStateDidChangeListener { _, user in
//            self.currentUser = user
//            self.currentUserID = user?.uid
//            completion(user?.uid)
//        }
//    }
    func listenFirebaseLoginSendAccount(completion: @escaping (Result<Account?, Error>) -> Void) {
        firebaseAuth.addStateDidChangeListener { _, user in
//            self.currentUser = user
//            self.currentUserID = user?.uid
            guard let id = user?.uid else { return }
            AccountRequestProvider.shared.fetchAccount(currentUserID: id) { result in
                switch result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func nativeSignIn(withEmail email: String, withPassword password: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("登入成功"))
            }
        }
    }

    func appleLogin(credential: AuthCredential, name: String?, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseAuth.signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let user = authResult?.user else { return }
            AccountRequestProvider.shared.checkUserDocExists(userID: user.uid) { isExist in
                if isExist {
                    print("已經註冊過了", user.uid)
                    completion(.success("登入成功"))
                } else {
                    var account = self.mappingAppleLoginUser(user: user, credential: credential, name: name)
                    AccountRequestProvider.shared.publishRegistedAccount(account: &account) { result in
                        switch result {
                        case let .success(string):
                            completion(.success(string))
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                }
            }
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
                case let .success(string):
                    completion(.success(string))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func nativePulishToClouldWithAuth(user: User, completion: @escaping (Result<String, Error>) -> Void) {
        var account = mappingNativeUser(user: user)
        AccountRequestProvider.shared.publishRegistedAccount(account: &account) { result in
            switch result {
            case let .success(string):
                completion(.success(string))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func mappingNativeUser(user: User) -> Account {
        let account = Account(userID: user.uid, provider: user.providerID)
        return account
    }

    func mappingAppleLoginUser(user: User, credential: AuthCredential, name: String?) -> Account {
        let userName = name ?? "新訪客"
        let account = Account(userID: user.uid, name: userName, provider: credential.provider)
        return account
    }

    func logOut() {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    func nativeDeleteAccount(password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let user = firebaseAuth.currentUser
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: password)
        user?.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                user?.delete(completion: { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success("刪除帳號成功"))
                    }
                })
            }
        }
    }
}
