//
//  StorePageViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import Kingfisher
import UIKit

class StorePageViewController: UIViewController {
    var commentData: [Comment] = []
    var storeData: Store?
    var userData: [Account] = []
    var currentUser: Account?

    let topView: StoreTopView = UIView.fromNib()
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        filterBlockedUser()
        setTopView()
        setupTableView()

        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.navigationBar.tintColor = .B1
    }

    func filterBlockedUser() {
        guard let currentUser = currentUser else {
            return
        }
        guard let list = currentUser.blockUserList else {
            return
        }
        commentData = commentData.filter {
            if !list.contains($0.userID) {
                return true
            } else {
                return false
            }
        }
    }

    func listenAuth() {
        UserRequestProvider.shared.listenFirebaseLoginSendAccount { result in
            switch result {
            case let .success(data):
                self.currentUser = data
                self.filterBlockedUser()
            case let .failure(error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }

    func setTopView() {
        topView.isHidden = true
        topView.delegate = self
        guard let storeData = storeData else { return }
        navigationController?.navigationBar.stickSubView(topView, inset: UIEdgeInsets(top: 4, left: 40, bottom: 4, right: 0))
        topView.layOutView(store: storeData, isCollect: isCollectedStore(storeData, currentUser))
    }

    func isCollectedStore(_ storeData: Store?, _ currentUser: Account?) -> Bool {
        guard let storeData = storeData, let currentUser = currentUser else { return false }
        return currentUser.collectedStore.contains(storeData.storeID)
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        topView.isHidden = true
    }

    func setupTableView() {
        tableView.backgroundColor = .B6
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellWithNib(identifier: StoreTitleCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: StoreImageCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: StoreTagsCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: StoreMealsCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: StoreLocaltionCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: StoreOpenTimeCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: StoreCommentCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: StoreRatingCell.identifier, bundle: nil)
    }

    func fetchUserData() {
        AccountRequestProvider.shared.fetchAccounts { result in
            switch result {
            case let .success(data):
                self.userData = data
                self.tableView.reloadSections([1], with: .automatic)
            case .failure:
                LKProgressHUD.showFailure(text: "載入用戶資料失敗/n請退出重試")
            }
        }
    }

    func congifMostLikeImage() -> [String] {
        let sortedComment = commentData.sorted { $0.likedUserList.count > $1.likedUserList.count }
        var imageArray = ["noData", "noData", "noData"]
        for i in 0 ..< sortedComment.count {
            imageArray[i] = sortedComment[i].mainImage
            if i == 2 {
                break
            }
        }
        return imageArray
    }
}

extension StorePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
            let comment = commentData.sorted { $0.createdTime > $1.createdTime }[indexPath.row]
            controller.modalPresentationStyle = .fullScreen
            controller.comment = comment
            controller.accountData = userData
            controller.store = storeData
            controller.currentUser = currentUser
            controller.author = userData.first { $0.userID == comment.userID }

            present(controller, animated: true, completion: nil)
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
        2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else {
            if userData.isEmpty {
                return 0
            } else {
                return commentData.count
            }
        }
    }

    //     swiftlint:disable cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let storeData = storeData else { return UITableViewCell() }
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreTitleCell.identifier, for: indexPath) as? StoreTitleCell else { return StoreTitleCell() }
                cell.delegate = self
                cell.layoutCell(store: storeData, isCollect: isCollectedStore(storeData, currentUser))
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreImageCell.identifier, for: indexPath) as? StoreImageCell else { return StoreImageCell() }
                cell.delegate = self
                cell.layoutCell(mostLikeImage: congifMostLikeImage())
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreTagsCell.identifier, for: indexPath) as? StoreTagsCell else { return StoreTagsCell() }
                cell.layoutCell(store: storeData)
                return cell
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreMealsCell.identifier, for: indexPath) as? StoreMealsCell else { return StoreMealsCell() }
                cell.layoutCell(store: storeData)
                return cell
            case 4:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreLocaltionCell.identifier, for: indexPath) as? StoreLocaltionCell else { return StoreLocaltionCell() }
                cell.layoutCell(localtion: storeData.address)
                return cell
            case 5:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreOpenTimeCell.identifier, for: indexPath) as? StoreOpenTimeCell else { return StoreOpenTimeCell() }
                cell.layoutCell(openTime: storeData.opentime)
                return cell
            case 6:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreLocaltionCell.identifier, for: indexPath) as? StoreLocaltionCell else { return StoreLocaltionCell() }
                cell.layoutCell(seat: storeData.seat)
                return cell
            case 7:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreRatingCell.identifier, for: indexPath) as? StoreRatingCell else { return StoreRatingCell() }
                cell.layoutCell(comments: commentData)
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreCommentCell.identifier, for: indexPath) as? StoreCommentCell else { return StoreCommentCell() }
            guard let currentUser = currentUser else { return cell }
            let comment = commentData.sorted { $0.createdTime > $1.createdTime }[indexPath.row]
            guard let author = userData.first(where: { $0.userID == comment.userID }) else { return cell }

            cell.delegate = self

            let isfollow = currentUser.followedUser.contains(comment.userID)
            let isLike = currentUser.likedComment.contains(comment.commentID)

            cell.layoutView(author: author, comment: comment, isFollow: isfollow, isLike: isLike)

            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.hexStringToUIColor(hex: "#fafafa")
            } else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
    }

    // swiftlint:enable cyclomatic_complexity
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 80
            case 1:
                return UIScreen.width / 1.5 - 20
            case 7:
                guard let naviHeight = navigationController?.navigationBar.bounds.height else { return 150 }
                let window = UIApplication.shared.windows[0]
                let safeFrame = window.safeAreaLayoutGuide.layoutFrame.minY
                let height = UIScreen.height - 80 - ( UIScreen.width / 1.5 - 20 ) - 250 - naviHeight - safeFrame
                if height > 150 {
                    return height
                } else {
                return 150
                }
            default:
                return 50
            }
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_: UITableView, didEndDisplaying _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            if isCollectedStore(storeData, currentUser) {
                topView.collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
            } else {
                topView.collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
            }
            topView.isHidden = false
        }
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            topView.isHidden = true
        }
    }
}

extension StorePageViewController: StoreTitleCellDelegate {
    func didtapCollectionButton(view _: StoreTitleCell) {
        guard let user = currentUser, let store = storeData else { return }
        StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case let .success(message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }

    func didtapUnCollectionButton(view _: StoreTitleCell) {
        guard let user = currentUser, let store = storeData else { return }
        StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case let .success(message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }

    func didtapWhenNotLogin(view _: StoreTitleCell) {
        presentWelcomePage()
    }
}

extension StorePageViewController: StoreTopViewDelegate {
    func didtapCollectionButton(_: StoreTopView) {
        guard let user = currentUser, let store = storeData else { return }
        StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case let .success(message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }

    func didtapUnCollectionButton(_: StoreTopView) {
        guard let user = currentUser, let store = storeData else { return }
        StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case let .success(message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }

    func didtapWhenNotLogin(_: StoreTopView) {
        presentWelcomePage()
    }

    func presentWelcomePage() {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else { return }
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
}

extension StorePageViewController: StoreImageCellDelegate {
    func didTapPopularImage(_ view: StoreImageCell, image: UIImage) {
        showImage(image: image)
    }

    func didTapmenuImage(_: StoreImageCell, image: UIImage) {
        showImage(image: image)
    }

    func didTapmoreImage(_: StoreImageCell, image _: UIImage) {
        if !commentData.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
        }
    }

    @objc func dissmiss(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    func showImage(image: UIImage) {
        let view: FullScreenView = UIView.fromNib()
        view.imageView.image = image
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmiss))
        view.addGestureRecognizer(tap)
        self.view.stickSubView(view)
    }
}

extension StorePageViewController {
    func showAlert(targetUser: String?) {
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
            self.commentData = self.commentData.filter {
                if $0.userID != targetUser {
                    return true
                } else {
                    return false
                }
            }
            self.tableView.reloadSections([1], with: .automatic)
        })

        alert.addAction(UIAlertAction(title: "取消", style: .cancel))

        present(alert, animated: true)
    }
    //    func blockUser(completion: @escaping () -> Void) {
    //        self.commentData = self.commentData.filter({
    //            if $0.userID != targetUser {
    //                return true
    //            } else {
    //                return false
    //            }
    //        })
    //       completion()
    //    }
}

extension StorePageViewController: StoreCommentCellDelegate {
    func didtapAuthor(_: StoreCommentCell, targetUserID: String?) {
        if UserRequestProvider.shared.currentUser != nil {
            guard let userID = UserRequestProvider.shared.currentUserID, let targetUser = targetUserID else { return }
            if targetUser != userID {
                showAlert(targetUser: targetUserID)
            } else {
                navigationController?.tabBarController?.selectedIndex = 3
            }
        } else {
            presentWelcomePage()
        }
    }

    func didtapLike(_: StoreCommentCell, targetComment: Comment?, isLogin _: Bool, isLike: Bool) {
        if UserRequestProvider.shared.currentUser != nil {
            guard let userID = UserRequestProvider.shared.currentUserID, let targetComment = targetComment else { return }
            if isLike {
                CommentRequestProvider.shared.likeComment(currentUserID: userID, tagertComment: targetComment)
            } else {
                CommentRequestProvider.shared.unLikeComment(currentUserID: userID, tagertComment: targetComment)
            }
        } else {
            presentWelcomePage()
        }
    }

    func didtapfollow(_: StoreCommentCell, targetUserID: String?, isLogin _: Bool, isFollow: Bool) {
        if UserRequestProvider.shared.currentUser != nil {
            guard let userID = UserRequestProvider.shared.currentUserID, let targetUserID = targetUserID else { return }
            if isFollow {
                AccountRequestProvider.shared.followAccount(currentUserID: userID, tagertUserID: targetUserID)
            } else {
                AccountRequestProvider.shared.unfollowAccount(currentUserID: userID, tagertUserID: targetUserID)
            }
        } else {
            presentWelcomePage()
        }
    }

    func didtapMore(_: StoreCommentCell, targetUserID: String?, isLogin _: Bool) {
        if UserRequestProvider.shared.currentUser != nil {
            guard let userID = UserRequestProvider.shared.currentUserID, let targetUser = targetUserID else { return }
            if targetUser != userID {
                showAlert(targetUser: targetUserID)
            } else {
                navigationController?.tabBarController?.selectedIndex = 3
            }
        } else {
            presentWelcomePage()
        }
    }
}

extension StorePageViewController: SignInAndOutViewControllerDelegate {
    func didSelectLookAround(_: SignInAndOutViewController) {
        navigationController?.popViewController(animated: true)
        tabBarController?.selectedIndex = 0
    }

    func didSelectGoEditProfile(_: SignInAndOutViewController) {
        navigationController?.popViewController(animated: true)
        tabBarController?.selectedIndex = 3
    }
}
