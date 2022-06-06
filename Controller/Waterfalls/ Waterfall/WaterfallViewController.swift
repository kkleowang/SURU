//
//  DiscoveryViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import CHTCollectionViewWaterfallLayout
import Firebase
import FirebaseFirestoreSwift
import UIKit
import XLPagerTabStrip

enum PageStatus {
    case discovery
    case follow
    case collect
}

class WaterfallViewController: UIViewController {
    var pageStatus: PageStatus?

    var commentData: [Comment] = []
    var currentAccount: Account?
    var storeData: [Store] = []

    var filteredCommentData: [Comment] = []
    var accountData: [Account] = []

    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addlistener()
        fetchAllData {
            self.configData {
                self.setupCollectionView()
                self.collectionView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCommentData {
            self.configData {
                self.collectionView.reloadData()
            }
        }
    }

    private func configData(completion: @escaping () -> Void) {
        guard let user = currentAccount, let blockList = user.blockUserList, let pageStatus = pageStatus else { return }
        switch pageStatus {
        case .discovery:
            filteredCommentData = commentData.filter { comment in
                if !blockList.contains(comment.userID) {
                    return true
                } else {
                    return false
                }
            }
        case .follow:
            filteredCommentData = commentData.filter { comment in
                if !blockList.contains(comment.userID), user.followedUser.contains(comment.userID) {
                    return true
                } else {
                    return false
                }
            }
        case .collect:
            filteredCommentData = commentData.filter { comment in
                if !blockList.contains(comment.userID), user.collectedStore.contains(comment.storeID) {
                    return true
                } else {
                    return false
                }
            }
        }
        completion()
    }

    func updataStore() {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case let .success(data):
                self.storeData = data
                self.configData {
                    self.collectionView.reloadData()
                }
            case let .failure(error):
                print("下載商店資料失敗", error)
            }
        }
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .B6
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 4
        layout.minimumInteritemSpacing = 4
        let inset = UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 4)
        layout.sectionInset = inset
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: DiscoveryCell.identifier, bundle: nil), forCellWithReuseIdentifier: DiscoveryCell.identifier)
    }

    func fetchCommentData(com: @escaping () -> Void) {
        CommentRequestProvider.shared.fetchComments { result in
            switch result {
            case let .success(data):
                self.commentData = data
                com()
            case let .failure(error):
                print("評論頁下載帳號失敗", error)
                com()
            }
        }
    }
}

extension WaterfallViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return filteredCommentData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoveryCell.identifier, for: indexPath) as? DiscoveryCell else { return DiscoveryCell() }
        cell.delegate = self
        if !filteredCommentData.isEmpty {
            let comment = filteredCommentData[indexPath.row]
            let store = storeData.first { $0.storeID == comment.storeID } ?? storeData[0]
            let account = accountData.first { $0.userID == comment.userID } ?? accountData[0]
            if let currentAccount = currentAccount {
                cell.layoutCell(author: account, comment: comment, currentUser: currentAccount, store: store)
            }
        }

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !filteredCommentData.isEmpty {
            let comment = filteredCommentData[indexPath.row]
            let store = storeData.first { $0.storeID == comment.storeID } ?? storeData[0]
            let account = accountData.first { $0.userID == comment.userID } ?? accountData[0]
            if let currentAccount = currentAccount {
                guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }

                controller.delegate = self
                
                controller.modalPresentationStyle = .fullScreen
                
                controller.comment = comment
                controller.accountData = accountData
                controller.store = store
                controller.currentUser = currentAccount
                
                controller.author = account
                present(controller, animated: true, completion: nil)
            }
        }
    }
}

extension WaterfallViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comment = filteredCommentData[indexPath.row]
        let store = storeData.first { $0.storeID == comment.storeID }

        let storeName = store?.name ?? ""
        let mealName = comment.meal

        let imageWidth = (UIScreen.width - 4 * 3) / 2
        let labelWidth = imageWidth - 16
        let storeLabelSize = labelSize(for: storeName, font: .medium(size: 16), maxWidth: labelWidth, maxHeight: 60)
        let mealLabelSize = labelSize(for: mealName, font: .medium(size: 14), maxWidth: labelWidth, maxHeight: 60)
        let height = imageWidth + storeLabelSize.height + mealLabelSize.height + 4 + 8 + 30 + 8 + 20 + 8


        return CGSize(width: imageWidth, height: height)
    }

    func labelSize(for text: String, font: UIFont?, maxWidth: CGFloat, maxHeight: CGFloat) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [.font: font as Any]

        let attributedText = NSAttributedString(string: text, attributes: attributes)

        let constraintBox = CGSize(width: maxWidth, height: maxHeight)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral

        return rect.size
    }
}

extension WaterfallViewController: IndicatorInfoProvider {
    func indicatorInfo(for _: PagerTabStripViewController) -> IndicatorInfo {
        guard let pageStatus = pageStatus else {
            return IndicatorInfo(title: NSLocalizedString("", comment: "barTagString"))
        }
        var indicatorTitle = ""
        switch pageStatus {
        case .discovery:
            indicatorTitle = "推薦"
        case .follow:
            indicatorTitle = "追隨"
        case .collect:
            indicatorTitle = "收藏"
        }
        return IndicatorInfo(title: NSLocalizedString(indicatorTitle, comment: "barTagString"))
    }
}

extension WaterfallViewController {
    func fetchAllData(com: @escaping () -> Void) {
        guard let currentUser = UserRequestProvider.shared.currentUser else { return }
        let group = DispatchGroup()
        let concurrentQueue1 = DispatchQueue(label: "com.leowang.queue1", attributes: .concurrent) //
        let concurrentQueue2 = DispatchQueue(label: "com.leowang.queue2", attributes: .concurrent)
        let concurrentQueue3 = DispatchQueue(label: "com.leowang.queue3", attributes: .concurrent)
        let concurrentQueue4 = DispatchQueue(label: "com.leowang.queue4", attributes: .concurrent)
        LKProgressHUD.show()
        group.enter()
        concurrentQueue1.async(group: group) {
            AccountRequestProvider.shared.fetchAccounts { result in
                switch result {
                case let .success(data):
                    print("下載1 全部帳號成功")
                    self.accountData = data
                case let .failure(error):
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
                case let .success(data):
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
                case let .failure(error):
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
                case let .success(data):
                    print("下載3 商店資料成功")
                    self.storeData = data
                case let .failure(error):
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
                case let .success(data):
                    print("下載4 評論成功")
                    self.commentData = data
                case let .failure(error):
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

    func addlistener() {
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        AccountRequestProvider.shared.listenAccount(currentUserID: userID) { result in
            switch result {
            case let .success(data):
                self.currentAccount = data
            case let .failure(error):
                print("更新用戶失敗", error)
            }
        }
    }
}

extension WaterfallViewController: DiscoveryCellDelegate {
    func didTapCommentBtn(_: DiscoveryCell, comment: Comment) {
        let store = storeData.first { $0.storeID == comment.storeID } ?? storeData[0]
        let account = accountData.first { $0.userID == comment.userID } ?? accountData[0]
        if let currentAccount = currentAccount {
            guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
            
            controller.delegate = self
            
            controller.modalPresentationStyle = .fullScreen
            controller.isClickComment = true
            controller.comment = comment
            controller.accountData = accountData
            controller.store = store
            controller.currentUser = currentAccount
            
            controller.author = account
            present(controller, animated: true, completion: nil)
        }
    }

    func didTapLikeButton(_: DiscoveryCell, comment: Comment) {
        guard let currentUserID = UserRequestProvider.shared.currentUserID else { return }
        CommentRequestProvider.shared.likeComment(currentUserID: currentUserID, tagertComment: comment)
    }

    func didTapUnLikeButton(_: DiscoveryCell, comment: Comment) {
        guard let currentUserID = UserRequestProvider.shared.currentUserID else { return }
        CommentRequestProvider.shared.unLikeComment(currentUserID: currentUserID, tagertComment: comment)
    }
}

extension WaterfallViewController: DetailViewControllerDelegate {
    func didtapAuthor(_: DetailViewController, targetUserID _: String?) {}

    func showAlert(targetUser: String?, vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = view

        let xOrigin = view.bounds.width / 2

        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)

        alert.popoverPresentationController?.sourceRect = popoverRect

        alert.popoverPresentationController?.permittedArrowDirections = .up
        alert.addAction(UIAlertAction(title: "封鎖用戶", style: .destructive) { _ in
            guard let userID = UserRequestProvider.shared.currentUserID, let targetUser = targetUser else { return }
            AccountRequestProvider.shared.blockAccount(currentUserID: userID, tagertUserID: targetUser)
            LKProgressHUD.showFailure(text: "成功封鎖用戶")
            self.filteredCommentData = self.filteredCommentData.filter {
                if $0.userID != targetUser {
                    return true
                } else {
                    return false
                }
            }
            self.collectionView.reloadData()
            vc.view.removeFromSuperview()
        })

        alert.addAction(UIAlertAction(title: "取消", style: .cancel))

        present(alert, animated: true)
    }
}
