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
    var UserData: [Account] = []
    var currentUser: Account? {
        didSet {
            setTopView()
        }
    }
    weak var delegate: SignInAndOutViewControllerDelegate?
    let topView: StoreTopView = UIView.fromNib()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBottomBarWhenPushed = true
        setTopView()
        registeCell()
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.tintColor = .B1
    }
    
    func setTopView() {
        topView.isHidden = true
        topView.delegate = self
        guard let storeData = storeData else { return }
        if currentUser != nil {
            isLogin = true
            isCollected = currentUser!.collectedStore.contains(storeData.storeID)
        } else {
            isLogin = false
            isCollected = false
        }
        navigationController?.navigationBar.stickSubView(topView, inset: UIEdgeInsets(top: 4, left: 40, bottom: 4, right: 0))
        topView.layOutView(store: storeData, isCollect: isCollected, isLogin: isLogin)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        topView.isHidden = true
    }
    func registeCell() {
        tableView.lk_registerCellWithNib(identifier: StoreTitleCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreImageCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreTagsCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreLocaltionCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreOpenTimeCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreCommentCell.identifier, bundle: nil)
//        tableView.lk_registerCellWithNib(identifier: StoreSeatsCell.identifier, bundle: nil)
        tableView.lk_registerCellWithNib(identifier: StoreRatingCell.identifier, bundle: nil)
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
                if sortedComment.count > 3 {
                    cell.layoutCell(popular: sortedComment[0].mainImage, menu: sortedComment[1].mainImage, more: sortedComment.randomElement()?.mainImage)
                } else {
                    cell.layoutCell(popular: "AppIcon", menu: "AppIcon", more: "AppIcon")
                }
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
                let layout = TagFlowLayout()
                layout.estimatedItemSize = CGSize(width: 30, height: 30)
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
                let layout = TagFlowLayout()
                layout.estimatedItemSize = CGSize(width: 30, height: 30)
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
                var soup: Double = 0
                var noodle: Double = 0
                var happy: Double = 0
                for comment in commentData {
                    soup += comment.contentValue.soup
                    noodle += comment.contentValue.noodle
                    happy += comment.contentValue.happiness
                }
                let count = Double(commentData.count)
                let data = [soup/count, noodle/count, happy/count]
                cell.layoutCell(data: data)
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreCommentCell.identifier, for: indexPath) as? StoreCommentCell else { return StoreCommentCell() }
            if isLogin {
//                cell.layoutView(author: <#T##Account#>, comment: <#T##Comment#>, isLogin: <#T##Bool#>, isFollow: <#T##Bool#>, isLike: <#T##Bool#>)
            } else {
                
            }
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
                return 200
            }
        } else {
            return 200
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
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
    func didtapCollectionWhenNotLogin(view: StoreTitleCell) {
        showAlert()
    }
    func didtapCollectionButton(view: StoreTitleCell) {
        guard let user = currentUser, let store = storeData else { return }
        if isCollected {
            StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
                switch result {
                case .success(let message):
                    LKProgressHUD.showSuccess(text: message)
                case .failure:
                    LKProgressHUD.showFailure(text: "更新失敗")
                }
            }
        } else {
            StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
                switch result {
                case .success(let message):
                    LKProgressHUD.showSuccess(text: message)
                case .failure:
                    LKProgressHUD.showFailure(text: "更新失敗")
                }
            }
        }
    }
}
extension StorePageViewController: StoreTopViewDelegate {
    func didTapCollect(_ view: StoreTopView, storeID: String) {
        guard let user = currentUser, let store = storeData else { return }
        if isCollected {
            StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
                switch result {
                case .success(let message):
                    LKProgressHUD.showSuccess(text: message)
                case .failure:
                    LKProgressHUD.showFailure(text: "更新失敗")
                }
            }
        } else {
            StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: store.storeID) { result in
                switch result {
                case .success(let message):
                    LKProgressHUD.showSuccess(text: message)
                case .failure:
                    LKProgressHUD.showFailure(text: "更新失敗")
                }
            }
        }
    }
    
    func didTapCollectWhenNotLogin(_ view: StoreTopView) {
        showAlert()
    }
    func showAlert() {
        let alert = UIAlertController(title: "提示", message: "登入後就能收藏店家囉！", preferredStyle: .alert)
        let login = UIAlertAction(title: "登入", style: .cancel) { _ in
            self.presentWelcomePage()
        }
        let notLogin = UIAlertAction(title: "下次一定", style: .default, handler: nil)
        alert.addAction(login)
        alert.addAction(notLogin)
        present(alert, animated: true, completion: nil)
    }
    func presentWelcomePage() {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else { return }
        controller.delegate = delegate
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
extension StorePageViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagsCell.self),
                                                            for: indexPath) as? TagsCell else { return TagsCell() }
        guard let storeData = storeData else { return TagsCell() }
        
        
        if collectionView.tag == 80 {
            cell.tagLabel.text = storeData.tags[indexPath.row]
            cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width
            cell.backgroundColor = .C4
            return cell
        } else {
            cell.layoutForMeal()
            cell.tagLabel.text = storeData.meals[indexPath.row]
            cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width
            cell.backgroundColor = .C2
            return cell
        }
        
    }
}
