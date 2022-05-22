//
//  SendCommentConmViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/17.
//

import UIKit

class CommentViewController: UIViewController {
    var startingView = CommentStartingView()
    var imageCardView = CommentImageCardView()
    var selectionView = CommentSelectionView()

    var orderObserver: NSKeyValueObservation!
    var stores: [Store] = []
    var comments: [Comment] = []
    var commentDrafts: [CommentDraft] = []
    let userID = UserRequestProvider.shared.currentUserID
    var commentData = Comment(
        userID: "",
        storeID: "",
        meal: "",
        contentValue: CommentContent(happiness: 0, noodle: 0, soup: 0),
        contenText: "",
        mainImage: ""
    )
    var originData = Comment(
        userID: "",
        storeID: "",
        meal: "",
        contentValue: CommentContent(happiness: 0, noodle: 0, soup: 0),
        contenText: "",
        mainImage: ""
    )
    // 上傳前的照片
    var imageDataHolder: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "新增評論"
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        commentData.userID = userID
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        settingKVO()
        navigationItem.title = "新增評論"
        fetchStoreData()
        fetchCoreData {}
        fetchCommentOfUser {
            self.setupStartingView()
        }
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

    func fetchCommentOfUser(com: @escaping () -> Void) {
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        CommentRequestProvider.shared.fetchCommentsOfUser(useID: userID) { result in
            switch result {
            case let .success(data):
                self.comments = data
                com()
            case let .failure(error):
                print(error)
                com()
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

    func setupImageCardView(_ image: UIImage) {
        imageCardView = CommentImageCardView()
        view.addSubview(imageCardView)
        imageCardView.translatesAutoresizingMaskIntoConstraints = false
        imageCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 84).isActive = true
        imageCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageCardView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        imageCardView.heightAnchor.constraint(equalTo: imageCardView.widthAnchor, multiplier: 1).isActive = true
        imageCardView.delegate = self
        //        imageCardView.clipsToBounds = true
        //        imageCardView.makeShadow()
        imageCardView.layoutCommendCardView(image: image) { [weak self] in
            self?.setupCommentSelectionView()
        }
    }

    func setupCommentSelectionView() {
        selectionView = CommentSelectionView()
        view.insertSubview(selectionView, belowSubview: imageCardView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.delegate = self
        selectionView.backgroundColor = .B6
        selectionView.topAnchor.constraint(equalTo: imageCardView.bottomAnchor, constant: 8).isActive = true
        selectionView.leadingAnchor.constraint(equalTo: imageCardView.leadingAnchor).isActive = true
        selectionView.trailingAnchor.constraint(equalTo: imageCardView.trailingAnchor).isActive = true
        selectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        selectionView.layoutSelectView(dataSource: stores)
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

    func publishComment() {
        CommentRequestProvider.shared.publishComment(comment: &commentData) { result in
            switch result {
            case let .success(message):
                print("上傳評論成功", message)
                LKProgressHUD.dismiss()
                LKProgressHUD.showSuccess(text: "上傳評論成功")
                //                self.sendButton.removeFromSuperview()
                self.fetchCommentOfUser {
                    self.setupStartingView()
                    self.commentData = self.originData
                }
            case let .failure(error):
                print("上傳評論失敗", error)
            }
        }
    }
}

// StartingView Delegate
extension CommentViewController: CommentStartingViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "你的評論草稿"
        } else {
            return "你發表過的評論"
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return commentDrafts.count
        } else {
            return comments.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            let name = stores.first { $0.storeID == commentDrafts[indexPath.row].storeID }?.name ?? "未輸入店名"
            cell.layoutDraftCell(data: commentDrafts[indexPath.row], name: name)
            return cell
        } else {
            let name = stores.first { $0.storeID == comments[indexPath.row].storeID }?.name ?? "未輸入店名"
            cell.layoutCommentCell(data: comments[indexPath.row], name: name)
            return cell
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let imageData = commentDrafts[indexPath.row].image else { return }
            guard let imageView = UIImage(data: imageData) else { return }
            setupImageCardView(imageView)
            startingView.removeFromSuperview()
        }
    }

    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage) {
        setupImageCardView(image)
        imageDataHolder = image.jpegData(compressionQuality: 0.1) ?? Data()
        imagePicker.dismiss(animated: true) {
            view.removeFromSuperview()
        }
    }

    func didTapImageView(_: CommentStartingView, imagePicker: UIImagePickerController?) {
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true) {
            self.startingView.commentTableView.removeFromSuperview()
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

    func didTapSaveComment(_: CommentSelectionView) {
        StorageManager.shared.addDraftComment(comment: commentData, image: imageDataHolder ?? Data()) { result in
            switch result {
            case let .success(data):
                print("Coredata")
            case let .failure(error):
                print(error)
            }
        }
        print("didTapSaveComment")
    }

    func didTapDownloadImage(_: CommentSelectionView) {
        print("didTapDownloadImage")
    }

    func didTapAddoneMore(_: CommentSelectionView) {
        print("didTapAddoneMore")
    }

    func didTapGoAllPage(_: CommentSelectionView) {
        print("didTapGoAllPage")
    }
}

extension CommentViewController: CommentDraggingViewDelegate {
    func didTapBackButton(vc: DragingValueViewController) {
        UIView.animate(withDuration: 0.5) {
            vc.view.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
            self.navigationItem.title = "新增評論"
            self.navigationController?.navigationBar.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
            self.imageCardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        }
        if commentData.contentValue.noodle != 0,
           commentData.contentValue.soup != 0,
           commentData.contentValue.happiness != 0,
           commentData.contentValue.noodle != 50,
           commentData.contentValue.soup != 50,
           commentData.contentValue.happiness != 50,
           !commentData.storeID.isEmpty, !commentData.meal.isEmpty
        {
            //            initSendButton()
            //            sendButton.isHidden = false
        }
    }
}

extension CommentViewController: LiquidViewDelegate {
    func didGetSelectionValue(view _: LiquidBarViewController, type: SelectionType, value: Double) {
        switch type {
        case .noodle:
            commentData.contentValue.noodle = value
            initValueView(on: selectionView.selectNoodelValueButton, value: value, color: UIColor.main1?.cgColor ?? UIColor.yellow.cgColor)

        case .soup:
            commentData.contentValue.soup = value
            initValueView(on: selectionView.selectSouplValueButton, value: value, color: UIColor.main2?.cgColor ?? UIColor.yellow.cgColor)

        case .happy:
            commentData.contentValue.happiness = value
            initValueView(on: selectionView.selectHappyValueButton, value: value, color: UIColor.main3?.cgColor ?? UIColor.yellow.cgColor)
        }
    }
}

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
    func didTapSendComment(_: WriteCommentView, text: String) {
        commentData.contenText = text
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

    func didTapSaveComment(_: WriteCommentView, text: String) {
        commentData.contenText = text
    }
}
