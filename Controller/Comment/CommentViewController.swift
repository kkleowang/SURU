//
//  SendCommentConmViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/17.
//

import UIKit

class CommentViewController: UIViewController {
    var startingView = CommentStartingView()
//    var imageCardView = CommentImageCardView()
//    var selectionView = CommentSelectionView()
    
    var orderObserver: NSKeyValueObservation!
    var stores: [Store] = []
    var comments: [Comment] = []
    var commentDrafts: [CommentDraft] = []
    var currentUserID: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        currentUserID = userID
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingKVO()
        navigationItem.title = "新增評論"
        fetchStoreData()
        fetchCoreData {}
        
        setupStartingView()
        
    }

    func settingKVO() {
        orderObserver = StorageManager.shared.observe(\StorageManager.comments, options: .new) { [weak self] _, _ in
            self?.startingView.commentTableView.reloadSections([0], with: .none)
        }
    }

    func fetchStoreData() {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case let .success(data):
                self.stores = data
            case let .failure(error):
                print(error)
            }
        }
    }

    func fetchCoreData(com: @escaping () -> Void) {
        StorageManager.shared.fetchComments { result in
            switch result {
            case let .success(data):
                self.commentDrafts = data
                com()
            case let .failure(error):
                print(error)
                com()
            }
        }
    }

    func setupStartingView() {
        startingView = CommentStartingView()
        view.addSubview(startingView)
        startingView.translatesAutoresizingMaskIntoConstraints = false
        startingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        startingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        startingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        startingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        startingView.commentTableView.isHidden = false
        startingView.commentTableView.delegate = self
        startingView.commentTableView.dataSource = self
        startingView.commentTableView.allowsSelection = true
        startingView.commentTableView.isUserInteractionEnabled = true
        startingView.delegate = self
        startingView.layoutStartingView()
    }

    

    func setupDraggingView(_ type: SelectionType) {
        let controller = DragingValueViewController()
        controller.liquilBarview.delegate = self
        controller.delegate = self
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.backgroundColor = UIColor.B5
        controller.view.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
        controller.view.corner(byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: 30)
        controller.setupLayout(type)
        UIView.animate(withDuration: 0.5) {
            self.tabBarController?.tabBar.isHidden = true
            controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: UIScreen.main.bounds.height)
        }
    }
    func initSelection(image: UIImage) {
        let controller = CommentSeletionController(userID: currentUserID, image: image)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func initSelectionByDraft(draft: CommentDraft) {
        let controller = CommentSeletionController(userID: currentUserID, draft: draft)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// StartingView Delegate
extension CommentViewController: CommentStartingViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        "你的評論草稿"
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentDrafts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell() }
        
        let name = stores.first(where: { $0.storeID == commentDrafts[indexPath.row].storeID })?.name ?? "未輸入店名"
        cell.layoutDraftCell(data: commentDrafts[indexPath.row], name: name)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        initSelectionByDraft(draft: commentDrafts[indexPath.row])
    }

    
    
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage) {
        initSelection(image: image)
        imagePicker.dismiss(animated: true)
    }

    func didTapImageView(_: CommentStartingView, imagePicker: UIImagePickerController?) {
        if let imagePicker = imagePicker {
            present(imagePicker, animated: true)
        }
    }
}

// CommentImageCardView Delegate
extension CommentViewController: CommentImageCardViewDelegate {
    func didFinishPickImage(_: CommentImageCardView, imagePicker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func didTapImageView(_ view: CommentImageCardView) {
        guard let imagePicker = view.imagePicker else { return }
        present(imagePicker, animated: true, completion: nil)
    }
}

extension CommentViewController: CommentSelectionViewDelegate {
    func didTapStoreSelection(_ view: CommentSelectionView) {
        let controller = SearchViewController()
        controller.storeData = stores
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didGetSelectStore(_: CommentSelectionView, storeID: String) {
        commentData.storeID = storeID
    }

    func didGetSelectMeal(_: CommentSelectionView, meal: String) {
        commentData.meal = meal
    }

    func didTapSelectValue(_: CommentSelectionView, type: SelectionType) {
        setupDraggingView(type)
    }

    func didTapWriteComment(_: CommentSelectionView) {
        preSentWriteCommentView()
    }

    func didTapNotWriteComment(_: CommentSelectionView) {
        preSentWriteCommentView()
    }

    func didTapSendComment(_: CommentSelectionView) {
        guard let image = imageDataHolder else { return }
        let fileName = "\(commentData.userID)_\(Date())"
        FirebaseStorageRequestProvider.shared.postImageToFirebaseStorage(data: image, fileName: fileName) { result in
            switch result {
            case let .success(url):
                print("上傳圖片成功", url.description)
                self.commentData.mainImage = url.description
                self.publishComment()
            case let .failure(error):
                print("上傳圖片失敗", error)
            }
        }
    }

}

//extension CommentViewController: CommentDraggingViewDelegate {
//    func didTapBackButton(vc: DragingValueViewController) {
//        UIView.animate(withDuration: 0.5) {
//            vc.view.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
//            self.navigationItem.title = "新增評論"
//            self.navigationController?.navigationBar.isHidden = false
//            self.tabBarController?.tabBar.isHidden = false
//            self.imageCardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
//        }
//        if commentData.contentValue.noodle != 0,
//           commentData.contentValue.soup != 0,
//           commentData.contentValue.happiness != 0,
//           commentData.contentValue.noodle != 50,
//           commentData.contentValue.soup != 50,
//           commentData.contentValue.happiness != 50,
//           !commentData.storeID.isEmpty, !commentData.meal.isEmpty
//        {
//            //            initSendButton()
//            //            sendButton.isHidden = false
//        }
//    }
//}

//extension CommentViewController: LiquidViewDelegate {
//    func didGetSelectionValue(view _: LiquidBarViewController, type: SelectionType, value: Double) {
//        switch type {
//        case .noodle:
//            commentData.contentValue.noodle = value
//            initValueView(on: selectionView.selectNoodelValueButton, value: value, color: UIColor.main1?.cgColor ?? UIColor.yellow.cgColor)
//
//        case .soup:
//            commentData.contentValue.soup = value
//            initValueView(on: selectionView.selectSouplValueButton, value: value, color: UIColor.main2?.cgColor ?? UIColor.yellow.cgColor)
//
//        case .happy:
//            commentData.contentValue.happiness = value
//            initValueView(on: selectionView.selectHappyValueButton, value: value, color: UIColor.main3?.cgColor ?? UIColor.yellow.cgColor)
//        }
//    }
//}

extension CommentViewController {
     
    func preSentWriteCommentView() {
        let controller = UIViewController()
        let writeCommentView: WriteCommentView = UIView.fromNib()
        writeCommentView.delegate = self
        controller.view.stickSubView(writeCommentView)
        let name = stores.first { $0.storeID == commentData.storeID }?.name ?? ""
        writeCommentView.layoutView(comment: commentData, name: name)
        present(controller, animated: true, completion: nil)
    }

    @objc func sendComment() {
        guard let image = imageDataHolder else { return }
        LKProgressHUD.show()
        let fileName = "\(commentData.userID)_\(Date())"
        FirebaseStorageRequestProvider.shared.postImageToFirebaseStorage(data: image, fileName: fileName) { result in
            switch result {
            case let .success(url):
                print("上傳圖片成功", url.description)
                self.commentData.mainImage = url.description

                self.publishComment()
            case let .failure(error):
                print("上傳圖片失敗", error)
            }
        }
    }

    func initValueView(on view: UIView, value: Double, color: CGColor) {
        let roundView = UIView(
            frame: CGRect(
                x: view.bounds.origin.x,
                y: view.bounds.origin.y,
                width: view.bounds.size.width - 4,
                height: view.bounds.size.height - 4
            )
        )
        roundView.backgroundColor = .B5
        roundView.layer.cornerRadius = roundView.frame.size.width / 2
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: roundView.bounds.width, height: roundView.bounds.height))
        label.center = CGPoint(x: roundView.center.x, y: roundView.center.y)
        label.textAlignment = .center
        label.text = "\(value)"
        label.font = .boldSystemFont(ofSize: 16)
        roundView.addSubview(label)
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
            radius: roundView.frame.size.width / 2,
            startAngle: CGFloat(-0.5 * .pi),
            endAngle: CGFloat(1.5 * .pi),
            clockwise: true
        )
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.strokeColor = color
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = 4
        // set start and end values
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = value * 0.1
        roundView.layer.addSublayer(circleShape)
        view.addSubview(roundView)
        view.backgroundColor = .B6
    }
}

extension CommentViewController: WrireCommentViewControllerDelegate {
    func didTapSaveDraft(_: WriteCommentView, text: String) {
        commentData.contenText = text
        let image = imageDataHolder ?? Data()
        StorageManager.shared.addDraftComment(comment: commentData, image: image) { result in
            switch result {
            case let .success(data):
                LKProgressHUD.showSuccess(text: "儲存草稿成功")
                self.setupStartingView()
                self.commentData = self.originData
                print("Coredata")
            case let .failure(error):
                LKProgressHUD.showFailure(text: "儲存草稿失敗")
                print(error)
            }
        }
    }

    func didTapSendComment(_: WriteCommentView, text: String) {
        commentData.contenText = text
        LKProgressHUD.show()
        guard let image = imageDataHolder else { return }
        let fileName = "\(commentData.userID)_\(Date())"
        FirebaseStorageRequestProvider.shared.postImageToFirebaseStorage(data: image, fileName: fileName) { result in
            switch result {
            case let .success(url):
                print("上傳圖片成功", url.description)
                self.commentData.mainImage = url.description
                self.publishComment()
            case let .failure(error):
                print("上傳圖片失敗", error)
            }
        }
    }
}
