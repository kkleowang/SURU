//
//  ProfileViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit

class ProfileViewController: UIViewController {
    var currentAccount: Account?
    
    var pageAccountId: String?
    
    //    var account: Account?
    
    var commentData: [Comment]?
    var storeData: [Store]?
    var accountData: [Account]? {
        didSet {
            checkUserBadgeStatus()
        }
    }
    
    
    var isOnPush = false
    
    var badgeRef: [[Int]]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        if pageAccountId == nil {
            isOnPush = false
            pageAccountId = UserRequestProvider.shared.currentUserID
            addlistener()
        } else {
            isOnPush = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData {
            self.checkUserBadgeStatus()
            self.setupTableView()
        }
        tableView.reloadData()
    }
    func setupTableView() {
        tableView.registerCellWithNib(identifier: ProfileBioCell.identifier, bundle: nil)
        tableView.registerHeaderWithNib(identifier: ProfileHeaderCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: ProfileCommentCell.identifier, bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.reloadData()
        //        tableView.sectionHeaderTopPadding = 0
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    func addlistener() {
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        AccountRequestProvider.shared.listenAccount(currentUserID: userID) { result in
            switch result {
            case .success(let data):
                print("更新用戶成功")
                if let index = self.accountData?.firstIndex { $0.userID == data.userID } {
                    self.accountData?[index] = data
                }
                
                self.currentAccount = data
                self.tableView.reloadData()
            case .failure(let error):
                print("更新用戶失敗", error)
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            guard let comment = commentData, let pageAccountId = pageAccountId else { return 0 }
            let data = comment.filter {
                if $0.userID == pageAccountId {
                    return true
                } else {
                    return false
                }
            }
            let lineNumber = ceil(Double(data.count) / 3.0)
            let height = (UIScreen.width - 3 * 2) / 3 * lineNumber
            return height
        } else {
            return UITableView.automaticDimension
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.width / 375 * 230
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileBioCell.identifier, for: indexPath) as? ProfileBioCell else { return ProfileBioCell() }
            guard let accountData = accountData?.first(where: { $0.userID == pageAccountId }) else { return  ProfileBioCell() }
            let bio = accountData.bio ?? "哈囉我是LEO"
            //            let badge = badgeRef ?? []
            cell.layoutCell(bio: bio)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCommentCell.identifier, for: indexPath) as? ProfileCommentCell else { return ProfileCommentCell() }
            guard let comment = commentData, let pageAccountId = pageAccountId else { return ProfileCommentCell() }
            let data = comment.filter({
                if $0.userID == pageAccountId {
                    return true
                } else {
                    return false
                }
            }).sorted(by: {$0.createdTime > $1.createdTime})
            cell.layoutCell(commentData: data)
            return cell
            
        default :
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeaderCell.identifier) as? ProfileHeaderCell else { return ProfileHeaderCell() }
            guard let userId = UserRequestProvider.shared.currentUserID, let pageAccountId = pageAccountId else { return ProfileHeaderCell() }
            header.delegate = self
            var isCurrent = true
            if  userId != pageAccountId {
                isCurrent = false
            }
            let data = accountData ?? []
            let accountData = data.first { $0.userID == pageAccountId } ?? Account(userID: "", provider: "")
            header.layoutHeaderCell(isOnPush: isOnPush, isCurrenAccount: isCurrent, account: accountData)
            return header
        } else {
            return nil
        }
    }
}
extension ProfileViewController: ProfileHeaderCellDelegate {
    func didtapBackBtn(_ view: ProfileHeaderCell) {
    }
    
    func didtapBadgeBtn(_ view: ProfileHeaderCell) {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "BadgeViewController") as? BadgeViewController else { return }
        guard let currentUserData = self.currentAccount else { return }
        controller.badgeRef = self.badgeRef
        controller.seletedBadgeName = currentUserData.badgeStatus
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didtapSettingBtn(_ view: ProfileHeaderCell, targetUserID: String?) {
        showAlert()
    }
    
    func didtapPost(_ view: ProfileHeaderCell) {
    }
    
    func didtapFans(_ view: ProfileHeaderCell) {
    }
    
    func didtapFollower(_ view: ProfileHeaderCell) {
    }
}

extension ProfileViewController {
    private func fetchData(competion: @escaping () -> Void) {
        let group = DispatchGroup()
        let concurrentQueue1 = DispatchQueue(label: "com.leowang.queue1", attributes: .concurrent)
        let concurrentQueue2 = DispatchQueue(label: "com.leowang.queue2", attributes: .concurrent)
        let concurrentQueue3 = DispatchQueue(label: "com.leowang.queue3", attributes: .concurrent)
        
        LKProgressHUD.show(text: "讀取使用者資訊中")
        group.enter()
        concurrentQueue1.async(group: group) {
            StoreRequestProvider.shared.fetchStores { result in
                switch result {
                case .success(let data) :
                    self.storeData = data
                case .failure(let error) :
                    print("下載商店資料失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載商店資料失敗")
                }
                group.leave()
            }
        }
        
        group.enter()
        concurrentQueue2.async(group: group) {
            CommentRequestProvider.shared.fetchComments { result in
                switch result {
                case .success(let data) :
                    self.commentData = data
                case .failure(let error) :
                    print("下載評論失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載評論失敗")
                }
                group.leave()
            }
        }
        group.enter()
        concurrentQueue3.async(group: group) {
            AccountRequestProvider.shared.fetchAccounts { result in
                switch result {
                case .success(let data) :
                    self.accountData = data
                case .failure(let error) :
                    print("載入使用者失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "載入使用者失敗")
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

extension ProfileViewController {
    func checkUserBadgeStatus() {
        
        guard let user = accountData?.first(where: { $0.userID == pageAccountId }) else { return }
        
        let followerCount = user.follower.count
        let loginCount = user.loginHistory?.count ?? 0
        let publishCommentCount = user.commentCount
        let publishReportCount = user.sendReportCount ?? 0
        let likeCount = user.myCommentLike ?? 0
        
        let loginCountManager = BadgeTierManager(tierCondition: [1, 3, 7, 15, 30])
        let likeCountManager = BadgeTierManager(tierCondition: [10, 30, 50, 100, 200])
        let commentCountManager = BadgeTierManager(tierCondition: [1, 5, 10, 20, 30])
        let followerCountManager = BadgeTierManager(tierCondition: [5, 10, 20, 30, 50])
        let reportCountManager = BadgeTierManager(tierCondition: [1, 5, 10, 15, 20])
            
            
        
        badgeRef = [
            loginCountManager.inRange(loginCount),
            commentCountManager.inRange( publishCommentCount),
            reportCountManager.inRange(publishReportCount),
            likeCountManager.inRange(likeCount),
            followerCountManager.inRange(followerCount)
        ]
        
    }
    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
        
        let xOrigin = self.view.bounds.width / 2
        
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        
        alert.popoverPresentationController?.sourceRect = popoverRect
        
        alert.popoverPresentationController?.permittedArrowDirections = .up
        
        alert.addAction(UIAlertAction(title: "登出帳號", style: .default) { _ in
            UserRequestProvider.shared.logOut()
            self.tabBarController?.selectedIndex = 0
            LKProgressHUD.showSuccess(text: "登出成功")
        })
        
        alert.addAction(UIAlertAction(title: "刪除帳號", style: .destructive) { _ in
            self.showDestructiveAlert()
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        self.present(alert, animated: true)
    }
    func showDestructiveAlert() {
        let alert = UIAlertController(title: "提示", message: "刪除帳號後資料永久不可復原，你確定要刪除帳號嗎？", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "再想想", style: .default)
        let cancelAction = UIAlertAction(title: "刪除帳號", style: .destructive) { _ in
            self.showAuthAlert()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func showAuthAlert() {
        let alert = UIAlertController(title: "輸入密碼", message: nil, preferredStyle: .alert)
        foriPad(alert: alert)
        alert.addTextField()
        alert.textFields![0].isSecureTextEntry = true
        let submitAction = UIAlertAction(title: "刪除帳號", style: .destructive) { [unowned alert] _ in
            guard let password = alert.textFields![0].text else { return }
            self.deleteAccount(password: password)
            self.tabBarController?.selectedIndex = 0
        }
        let okAction = UIAlertAction(title: "再想想", style: .cancel) { _ in
        }
        
        alert.addAction(submitAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    func foriPad(alert: UIAlertController) {
        alert.popoverPresentationController?.sourceView = self.view
        
        let xOrigin = self.view.bounds.width / 2
        
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        
        alert.popoverPresentationController?.sourceRect = popoverRect
        
        alert.popoverPresentationController?.permittedArrowDirections = .up
    }
    func deleteAccount(password: String) {
        guard let userID = UserRequestProvider.shared.currentUserID else {
            LKProgressHUD.showFailure(text: "刪除失敗 稍後再試")
            return
        }
        UserRequestProvider.shared.nativeDeleteAccount(password: password) { result in
            switch result {
            case .failure(let error):
                print("刪除失敗 稍後再試", error)
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
//extension ProfileViewController: ProfileViewDelegate {
//    func didTapBadge(_ view: ProfileView) {
//        //        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "BadgeViewController") as? BadgeViewController else { return }
//        //        guard let currentUserData = currentUserData else { return }
//        //        controller.badgeRef = badgeRef
//        //        controller.seletedBadgeName = currentUserData.badgeStatus
//        //                navigationController?.pushViewController(controller, animated: true)
//    }
//
//    func didTapEditProfilebutton(_ view: ProfileView) {
//        showEditingPage()
//    }
//
//    func didTapAccountButton(_ view: ProfileView) {
//        showAlert()
//    }
//    func showEditingPage() {
//        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else { return }
//        guard let userData = currentUserData else { return }
//        controller.userData = userData
//        controller.badgeRef = badgeRef
//        let nav = UINavigationController(rootViewController: controller)
//        nav.modalPresentationStyle = .fullScreen
//        present(nav, animated: true, completion: nil)
//    }
//



//}
