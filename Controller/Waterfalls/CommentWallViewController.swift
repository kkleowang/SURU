//
//  CommentWallViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import UIKit
import XLPagerTabStrip

class CommentWallViewController: ButtonBarPagerTabStripViewController {
//    var subVC: [String] = ["Discovery", "Collect", "Follow"]
    
    var accounts: [Account] = []
    var comments: [Comment] = []
    var stores: [Store] = []
    var currentAccount: Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments {
            self.setupTabStrip()
        }
    }
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let discoveryVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController") as! DiscoveryViewController
//        let collectVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController")
//        let followVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController")
        discoveryVC.commentData = comments
        
        return [discoveryVC, discoveryVC, discoveryVC]
    }
    
    private func setupTabStrip() {
        settings.style.selectedBarBackgroundColor = .C3!
        settings.style.selectedBarHeight = 3
        // button樣式
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0
        // Do any additional setup after loading the view.
        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
    }
}
// firebase
extension CommentWallViewController {
    func fetchAccounts() {
        AccountRequestProvider.shared.fetchAccounts { result in
            switch result {
            case .success(let data) :
                self.accounts = data
            case .failure(let error) :
                print("評論頁下載帳號失敗", error)
            }
        }
    }
    func fetchCurrentUserData() {
        guard let user = UserRequestProvider.shared.firebaseAuth.currentUser else { return }
        AccountRequestProvider.shared.fetchAccount(userID: user.uid) { result in
            switch result {
            case .success(let data) :
                self.currentAccount = data
            case .failure(let error) :
                print("評論頁下載帳號失敗", error)
            }
        }
    }
    func fetchStores() {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case .success(let data) :
                self.stores = data
                
            case .failure(let error) :
                print("評論頁下載帳號失敗", error)
            }
        }
    }
    func fetchComments(com: @escaping () -> ()) {
        CommentRequestProvider.shared.fetchComments { result in
            switch result {
            case .success(let data) :
                self.comments = data
                com()
            case .failure(let error) :
                print("評論頁下載帳號失敗", error)
            }
        }
    }
    
//    func getUserforComment(row: Int) -> Account? {
//        for account in accounts where account.userID == comments[row].userID{
//            return account
//        }
//        return accounts.first
//    }
//    func getStoreforComment(row: Int) -> Store? {
//        for store in stores where store.storeID == comments[row].storeID{
//            return store
//        }
//        return stores.first
//    }
}
