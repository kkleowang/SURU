//
//  ProfileViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileView: ProfileView = UIView.fromNib()
    var currentUserData: Account?
    var currentUserComment: [Comment]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData {
            self.view.stickSubView(self.profileView)
            self.profileView.delegate = self
            self.profileView.layoutView(account: self.currentUserData!)
        }
        
    }
}
extension ProfileViewController: ProfileViewDelegate {
    func didTapEditProfilebutton(_ view: ProfileView) {
        showEditingPage()
    }
    
    func didTapAccountButton(_ view: ProfileView) {
        showAlert()
    }
    func showEditingPage() {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else { return }
        guard let userData = currentUserData else { return }
        controller.userData = userData
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        
        
        present(nav, animated: true, completion: nil)
    }
    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "登出帳號", style: .default , handler:{ (UIAlertAction)in
            UserRequestProvider.shared.logOut()
            LKProgressHUD.showSuccess(text: "登出成功")
        }))
        
        alert.addAction(UIAlertAction(title: "刪除帳號", style: .destructive , handler:{ (UIAlertAction)in
            self.showDestructiveAlert()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    func showDestructiveAlert() {
        let alert = UIAlertController(title: "提示", message: "刪除帳號後資料永久不可復原，你確定要刪除帳號嗎？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "再想想", style: .default) { _ in
            
        }
        let cancelAction = UIAlertAction(title: "刪除帳號", style: .destructive) { _ in
            self.showAuthAlert()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func showAuthAlert() {
        let alert = UIAlertController(title: "輸入密碼", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].isSecureTextEntry = true
        let submitAction = UIAlertAction(title: "刪除帳號", style: .destructive) { [unowned alert] _ in
            guard let password = alert.textFields![0].text else { return }
            self.deleteAccount(password: password)
        }
        let okAction = UIAlertAction(title: "再想想", style: .cancel) { _ in
        }
        
        alert.addAction(submitAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    func deleteAccount(password: String) {
        guard let userID = UserRequestProvider.shared.currentUserID else {
            LKProgressHUD.showFailure(text: "刪除失敗 稍後再試")
            return
        }
        UserRequestProvider.shared.nativeDeleteAccount(password: password) { result in
            switch result {
            case .failure(let error):
                print("刪除失敗 稍後再試",error)
                LKProgressHUD.showFailure(text: error.localizedDescription)
            case .success(let message):
                self.deleteUserInfo(userID: userID)
                LKProgressHUD.showSuccess(text: message)
            }
        }
    }
    func deleteUserInfo(userID: String) {
        AccountRequestProvider.shared.deleteAccountInfo(userID: userID) { result in
            switch result {
            case .failure(let error):
                print("個人頁面刪除帳號資料庫失敗", error)
            case .success(let message):
                print("個人頁面刪除帳號資料庫成功", message)
            }
        }
    }
}
extension ProfileViewController {
    func fetchData(competion: @escaping () -> Void) {
        let group: DispatchGroup = DispatchGroup()
        let concurrentQueue1 = DispatchQueue(label: "com.leowang.queue1", attributes: .concurrent)
        let concurrentQueue2 = DispatchQueue(label: "com.leowang.queue2", attributes: .concurrent)
        LKProgressHUD.show(text: "讀取使用者資訊中")
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        group.enter()
        concurrentQueue1.async(group: group) {
            AccountRequestProvider.shared.fetchAccount(currentUserID: userID) { result in
                switch result {
                case .success(let data):
                    print("下載用戶成功")
                    self.currentUserData = data
                case .failure(let error):
                    print("下載用戶失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載用戶失敗")
                }
                group.leave()
            }
            
        }
        group.enter()
        concurrentQueue2.async(group: group) {
            CommentRequestProvider.shared.fetchCommentsOfUser(useID: userID) { result in
                switch result {
                case .success(let data) :
                    print("下載用戶評論成功")
                    self.currentUserComment = data
                case .failure(let error) :
                    print("下載用戶評論失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載評論失敗")
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            LKProgressHUD.dismiss()
            competion()
        }
    }
}

