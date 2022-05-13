//
//  DiscoveryViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import UIKit
import XLPagerTabStrip
import CHTCollectionViewWaterfallLayout
import Firebase
import FirebaseFirestoreSwift

class DiscoveryViewController: UIViewController {
    var commentData: [Comment] = []
    var currentAccount: Account?
    var storeData: [Store] = []
    
    var filteredCommentData: [Comment] = []
    //    var dataSourceComment: [Comment] = []
    var accountData: [Account] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        collectionView.backgroundColor = .B6
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        fetchAllData {
            self.configData {
                self.setupCollectionView()
                self.collectionView.reloadData()
            }
        }
        StoreRequestProvider.shared.listenStore {
            self.updataStore()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    private func configData(completion: @escaping () -> Void) {
        guard let user = currentAccount else { return }
        filteredCommentData = commentData.filter({comment in
            guard let blockList = user.blockUserList else { return true }
            if blockList.contains(comment.userID) {
                return false
            } else {
                return true
            }
        })
        
        completion()
    }
    func updataStore() {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case .success(let data) :
                self.storeData = data
                self.configData {
                    self.collectionView.reloadData()
                }
            case .failure(let error) :
                print("下載商店資料失敗", error)
            }
        }
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 4
        layout.minimumInteritemSpacing = 4
        let inset = UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 4)
        layout.sectionInset = inset
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: String(describing: DiscoveryCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: DiscoveryCell.self))
    }
    func fetchCommentData(com: @escaping () -> ()) {
        CommentRequestProvider.shared.fetchComments { result in
            switch result {
            case .success(let data) :
                self.commentData = data
                com()
            case .failure(let error) :
                print("評論頁下載帳號失敗", error)
                com()
            }
        }
    }
    
}

extension DiscoveryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCommentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DiscoveryCell.self)", for: indexPath) as? DiscoveryCell else { return DiscoveryCell() }
        cell.delegate = self
        if !filteredCommentData.isEmpty {
            let comment = filteredCommentData[indexPath.row]
            let store = storeData.first(where: {$0.storeID == comment.storeID}) ?? storeData[0]
            guard let account = accountData.first(where: {$0.userID == comment.userID}) else {
                print("崩潰拉")
                return cell }
            if let currentAccount = currentAccount {
                cell.layoutCell(author: account, comment: comment, currentUser: currentAccount, store: store)
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !filteredCommentData.isEmpty {
            let comment = filteredCommentData[indexPath.row]
            let store = storeData.first(where: {$0.storeID == comment.storeID})
            let account = accountData.first(where: {$0.userID == comment.userID})
            if let currentAccount = currentAccount {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
                controller.delegate = self
                controller.modalPresentationStyle = .fullScreen
                controller.comment = comment
                controller.store = store
                controller.account = account
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
}

extension DiscoveryViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DiscoveryCell.self), for: indexPath)
            
        let comment = filteredCommentData[indexPath.row]
        let store = storeData.first(where: {$0.storeID == comment.storeID})
        
        let text = store?.name ?? ""
        if text.count > 12 {
            return CGSize(width: (UIScreen.width - 10 * 3) / 2, height: 340)
        }
        if text.count < 8 {
            return CGSize(width: (UIScreen.width - 10 * 3) / 2, height: 320)
        }else {
            return CGSize(width: (UIScreen.width - 10 * 3) / 2, height: 330)
        }
    }
    
    
}
extension DiscoveryViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("推薦", comment: "barTagString"))
    }
}
extension DiscoveryViewController {
    func fetchAllData(com: @escaping () -> ()) {
        guard let currentUser = UserRequestProvider.shared.currentUser else { return }
        let group: DispatchGroup = DispatchGroup()
        let concurrentQueue1 = DispatchQueue(label: "com.leowang.queue1", attributes: .concurrent)
        let concurrentQueue2 = DispatchQueue(label: "com.leowang.queue2", attributes: .concurrent)
        let concurrentQueue3 = DispatchQueue(label: "com.leowang.queue3", attributes: .concurrent)
        let concurrentQueue4 = DispatchQueue(label: "com.leowang.queue4", attributes: .concurrent)
        LKProgressHUD.show()
        group.enter()
        concurrentQueue1.async(group: group) {
            AccountRequestProvider.shared.fetchAccounts { result in
                switch result {
                case .success(let data) :
                    print("下載1 全部帳號成功")
                    self.accountData = data
                case .failure(let error) :
                    print("下載1 全部帳號失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載帳號失敗")
                }
                group.leave()
            }
        }
        group.enter()
        
        concurrentQueue2.async(group: group) {
            AccountRequestProvider.shared.fetchAccount(currentUserID: currentUser.uid) { result in
                switch result {
                case .success(let data) :
                    if let data = data {
                        print("下載2 使用者成功")
                        self.currentAccount = data
                    } else {
                        UserRequestProvider.shared.nativePulishToClouldWithAuth(user: currentUser) { result in
                            switch result {
                            case .success:
                                print("下載2 註冊成功")
                            case .failure:
                                LKProgressHUD.dismiss()
                                LKProgressHUD.showFailure(text: "請聯繫客服")
                            }
                        }
                        group.leave()
                    }
                case .failure(let error) :
                    print("下載2 使用者失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載使用者失敗")
                }
                group.leave()
            }
            
        }
        group.enter()
        concurrentQueue3.async(group: group) {
            StoreRequestProvider.shared.fetchStores { result in
                switch result {
                case .success(let data) :
                    print("下載3 商店資料成功")
                    self.storeData = data
                case .failure(let error) :
                    print("下載3 商店資料失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載商店資料失敗")
                }
                group.leave()
            }
        }
        group.enter()
        concurrentQueue4.async(group: group) {
            CommentRequestProvider.shared.fetchComments { result in
                switch result {
                case .success(let data) :
                    print("下載4 評論成功")
                    self.commentData = data
                case .failure(let error) :
                    print("下載4 評論失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載評論失敗")
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            com()
            LKProgressHUD.dismiss()
            LKProgressHUD.showSuccess(text: "下載資料成功")
        }
    }
}

extension DiscoveryViewController: DiscoveryCellDelegate {
    func didTapCommentBtn(_ view: DiscoveryCell, comment: Comment) {
        //
    }
    func didTapLikeButton(_ view: DiscoveryCell, comment: Comment) {
        guard let currentUserID = UserRequestProvider.shared.currentUserID else { return }
        CommentRequestProvider.shared.likeComment(currentUserID: currentUserID, tagertComment: comment)
    }
    
    func didTapUnLikeButton(_ view: DiscoveryCell, comment: Comment) {
        guard let currentUserID = UserRequestProvider.shared.currentUserID else { return }
        CommentRequestProvider.shared.unLikeComment(currentUserID: currentUserID, tagertComment: comment)
    }
    
    
}
extension DiscoveryViewController: DetailViewControllerDelegate {
    func didtapAuthor(_ vc: DetailViewController, targetUserID: String?) {
        guard let userID = UserRequestProvider.shared.currentUserID, let targetUser = targetUserID else { return }
        if targetUser != userID {
            showAlert(targetUser: targetUserID, vc: vc)
        } else {
            navigationController?.tabBarController?.selectedIndex = 3
        }
        
    }
    func showAlert(targetUser: String?, vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
        
        let xOrigin = self.view.bounds.width / 2
        
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        
        alert.popoverPresentationController?.sourceRect = popoverRect
        
        alert.popoverPresentationController?.permittedArrowDirections = .up
        alert.addAction(UIAlertAction(title: "封鎖用戶", style: .destructive , handler:{ (UIAlertAction) in
            guard let userID = UserRequestProvider.shared.currentUserID, let targetUser = targetUser else { return }
            AccountRequestProvider.shared.blockAccount(currentUserID: userID, tagertUserID: targetUser)
            LKProgressHUD.showFailure(text: "成功封鎖用戶")
            self.filteredCommentData = self.filteredCommentData.filter({
                if $0.userID != targetUser {
                    return true
                } else {
                    return false
                }
            })
            self.collectionView.reloadData()
            vc.view.removeFromSuperview()
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}
