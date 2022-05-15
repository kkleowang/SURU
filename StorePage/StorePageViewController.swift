//
//  StorePageViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit
import Kingfisher

class StorePageViewController: UIViewController {
    var isCollected = false
    var isLogin = false {
        didSet {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            tableView.reloadSections([1], with: .automatic)
        }
    }
    var commentData: [Comment] = []
    var storeData: Store?
    var UserData: [Account] = [] {
        didSet {
            tableView.reloadSections([1], with: .automatic)
        }
    }
    var currentUser: Account? {
        didSet {
            configLoginStatus()
            setTopView()
        }
        
    }
    let topView: StoreTopView = UIView.fromNib()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        configLoginStatus()
        filterBlockedUser()
        setTopView()
        setupTableView()
        
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.navigationBar.tintColor = .B1
    }
    
    func filterBlockedUser() {
        if isLogin {
            guard let currentUser = currentUser else {
                return
            }
            guard let list = currentUser.blockUserList else {
                return
            }
            commentData = commentData.filter({
                if !list.contains($0.userID) {
                    return true
                } else {
                    return false
                }
            })
            tableView.reloadSections([1], with: .automatic)
        }
        
    }
    func listenAuth() {
        UserRequestProvider.shared.listenFirebaseLoginSendAccount { result in
            switch result {
            case .success(let data):
                self.currentUser = data
                self.filterBlockedUser()
            case .failure(let error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    func setTopView() {
        topView.isHidden = true
        topView.delegate = self
        guard let storeData = storeData else { return }
        
        navigationController?.navigationBar.stickSubView(topView, inset: UIEdgeInsets(top: 4, left: 40, bottom: 4, right: 0))
        topView.layOutView(store: storeData, isCollect: isCollected, isLogin: isLogin)
    }
    func configLoginStatus() {
        guard let storeData = storeData else { return }
        if currentUser != nil {
            isLogin = true
            isCollected = currentUser!.collectedStore.contains(storeData.storeID)
        } else {
            isLogin = false
            isCollected = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        topView.isHidden = true
    }
    
    func setupTableView() {
        tableView.backgroundColor = .B6
        tableView.dataSource = self
        tableView.delegate = self
        tableView.lk_registerCellWithNib(identifier: StoreTitleCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreImageCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreTagsCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreLocaltionCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreOpenTimeCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreCommentCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreRatingCell.identifier, bundle: nil)
        
    }
    func fetchUserData() {
        AccountRequestProvider.shared.fetchAccounts { result in
            switch result {
            case .success(let data):
                self.UserData = data
            case .failure:
                LKProgressHUD.showFailure(text: "載入用戶資料失敗/n請退出重試")
            }
        }
    }
    
}
extension StorePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else {
            return commentData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let storeData = storeData else { return UITableViewCell() }
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreTitleCell.identifier, for: indexPath) as? StoreTitleCell else { return StoreTitleCell() }
                cell.delegate = self
                cell.layoutCell(store: storeData, isCollect: isCollected, isLogin: isLogin)
                
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreImageCell.identifier, for: indexPath) as? StoreImageCell else { return StoreImageCell() }
                let sortedComment = commentData.sorted(by: {$0.likedUserList.count > $1.likedUserList.count})
                var imageArray = ["noData", "noData", "noData"]
                for i in 0..<sortedComment.count {
                    imageArray[i] = sortedComment[i].mainImage
                    if i == 2{
                        break
                    }
                }
                
                cell.layoutCell(popular: imageArray[0], menu: imageArray[1], more: imageArray[2])
                
                cell.delegate = self
                
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreTagsCell.identifier, for: indexPath) as? StoreTagsCell else { return StoreTagsCell() }
                cell.collectionView.register(UINib(nibName: String(describing: TagsCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TagsCell.self))
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.showsHorizontalScrollIndicator = false
                cell.collectionView.showsVerticalScrollIndicator = false
                cell.collectionView.tag = 80
                
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                layout.estimatedItemSize = CGSize(width: 60, height: 40)
                cell.collectionView.collectionViewLayout = layout
                
                return cell
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreTagsCell.identifier, for: indexPath) as? StoreTagsCell else { return StoreTagsCell() }
                cell.collectionView.register(UINib(nibName: String(describing: TagsCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TagsCell.self))
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.showsHorizontalScrollIndicator = false
                cell.collectionView.showsVerticalScrollIndicator = false
                cell.collectionView.tag = 90
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                layout.estimatedItemSize = CGSize(width: 50, height: 40)
                cell.collectionView.collectionViewLayout = layout
                cell.layoutForMealCell()
                
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
                var noodle: Double = 0
                var soup: Double = 0
                var happy: Double = 0
                for comment in commentData {
                    noodle += comment.contentValue.noodle
                    soup += comment.contentValue.soup
                    happy += comment.contentValue.happiness
                }
                let count = Double(commentData.count)
                let data = [noodle/count, soup/count, happy/count]
                cell.layoutCell(data: data)
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreCommentCell.identifier, for: indexPath) as? StoreCommentCell else { return StoreCommentCell() }
            cell.delegate = self
            let comment = commentData.sorted(by: {$0.createdTime > $1.createdTime})[indexPath.row]
            
            guard let author = UserData.first(where: {$0.userID == comment.userID}) else { return cell }
            var isfollow = false
            var isLike = false
            if UserRequestProvider.shared.currentUserID != nil {
                guard let user = currentUser else { return cell }
                isLike =  comment.likedUserList.contains(user.userID)
                isfollow = user.followedUser.contains(comment.userID)
            }
            cell.layoutView(author: author, comment: comment, isLogin: isLogin, isFollow: isfollow, isLike: isLike)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 80
            case 1:
                
                return UIScreen.width/1.5 - 20
            case 2:
                
                return 50
            case 3:
                
                return 50
            case 4:
                
                return 50
            case 5:
                
                return 50
            case 6:
                return 50
            case 7:
                return 150
            default:
                return 10
            }
        } else {
            return UITableView.automaticDimension
        }
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 0
//        }else {
//            return 20
//        }
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if section == 0 {
//            let headerView = UIView()
//            headerView.backgroundColor = UIColor.red
//            return headerView
//        }else {
//            let headerView = UIView()
//            headerView.backgroundColor = UIColor.clear
//            return headerView
//        }
//    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            
            if isCollected {
                topView.collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
            } else {
                topView.collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
            }
            
            topView.isHidden = false
            print("ENDENDE")
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            topView.isHidden = true
        }
    }
}
extension StorePageViewController: StoreTitleCellDelegate {
    func didtapCollectionButton(view: StoreTitleCell) {
        guard let user = currentUser, let store = storeData else { return }
        isCollected = true
        StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }
    func didtapUnCollectionButton(view: StoreTitleCell) {
        isCollected = false
        guard let user = currentUser, let store = storeData else { return }
        StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }
    func didtapWhenNotLogin(view: StoreTitleCell) {
        presentWelcomePage()
    }
}
extension StorePageViewController: StoreTopViewDelegate {
    func didtapCollectionButton(_ view: StoreTopView) {
        guard let user = currentUser, let store = storeData else { return }
        isCollected = true
        StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }
    
    func didtapUnCollectionButton(_ view: StoreTopView) {
        isCollected = false
        guard let user = currentUser, let store = storeData else { return }
        StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "更新失敗")
            }
        }
    }
    
    func didtapWhenNotLogin(_ view: StoreTopView) {
        presentWelcomePage()
    }
    
    
    func presentWelcomePage() {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else { return }
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
}
extension StorePageViewController: StoreImageCellDelegate {
    func didTapPopularImage(_ view: StoreImageCell, image: UIImage) {
        let view: fullScreenImageView = UIView.fromNib()
        view.imageView.image = image
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmiss))
        view.addGestureRecognizer(tap)
        self.view.stickSubView(view)
        
        print("didTapPopularImage")
    }
    
    func didTapmenuImage(_ view: StoreImageCell, image: UIImage) {
        print("didTapmenuImage")
    }
    
    func didTapmoreImage(_ view: StoreImageCell, image: UIImage) {
        print("didTapmoreImage")
    }
    @objc func dissmiss(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    
}
extension StorePageViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let storeData = storeData else { return 0 }
        if collectionView.tag == 80 {
            return storeData.tags.count
        } else {
            return storeData.meals.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagsCell.self), for: indexPath) as? TagsCell else { return TagsCell() }
        guard let storeData = storeData else { return TagsCell() }
        
        
        if collectionView.tag == 80 {
            cell.tagLabel.text = storeData.tags[indexPath.row]
//            cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width
            cell.backgroundColor = .C4
            return cell
        } else {
            cell.layoutForMeal()
            cell.tagLabel.text = storeData.meals[indexPath.row]
//            cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width
            cell.backgroundColor = .C2
            return cell
        }
    }
    func showAlert(targetUser: String?) {
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
            self.commentData = self.commentData.filter({
                if $0.userID != targetUser {
                    return true
                } else {
                    return false
                }
            })
            self.tableView.reloadSections([1], with: .automatic)
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
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
    func didtapAuthor(_ view: StoreCommentCell, targetUserID: String?) {
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
    
    func didtapLike(_ view: StoreCommentCell, targetComment: Comment?, isLogin: Bool, isLike: Bool) {
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
    
    func didtapfollow(_ view: StoreCommentCell, targetUserID: String?, isLogin: Bool, isFollow: Bool) {
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
    
    func didtapMore(_ view: StoreCommentCell, targetUserID: String?, isLogin: Bool) {
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
    func didSelectLookAround(_ view: SignInAndOutViewController) {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }
    
    func didSelectGoEditProfile(_ view: SignInAndOutViewController) {
        navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 3
    }
    
    
}
