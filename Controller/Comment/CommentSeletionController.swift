//
//  CommentSeletionController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/7.
//

import UIKit

class CommentSeletionController: UIViewController {
    lazy var selectionView = SeletionView(frame: .zero, topBarHeight: self.topbarHeight)
    var mainImage: UIImage!
    var comment: Comment!
    var stores: [Store]!
    var draftData: CommentDraft!
    var isDraft = false
    var imageDataHolder: Data!
    var isButtonClick = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .B1
        configSeletionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    init(userID: String, draft: CommentDraft, storeData: [Store]) {
        let imageData = draft.image ?? Data()
        let image = UIImage(data: imageData)
        self.mainImage = image
        self.comment = defultComment
        self.comment.userID = userID
        self.stores = storeData
        self.draftData = draft
        super.init(nibName: nil, bundle: nil)
    }
    
    init(userID: String, image: UIImage, storeData: [Store]) {
        self.mainImage = image
        imageDataHolder = image.jpegData(compressionQuality: 0.1) ?? Data()
        self.comment = defultComment
        self.comment.userID = userID
        self.stores = storeData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configSeletionView() {
        view.stickSubView(selectionView)
        selectionView.configView(image: mainImage)
        selectionView.delegate = self
    }
    func initSecrchController(storeID: String? = nil) {
        let controller = SearchViewController()
        controller.storeData = stores
        controller.delegate = self
        if let storeID = storeID {
            controller.mealData = stores.first(where: { $0.storeID == storeID })?.meals
            controller.searchPlaceholder = "搜尋品項"
            controller.isMealSelection = true
            controller.selectStoreID = storeID
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func setupDraggingView(_ type: SelectionType) {
        let controller = DragingValueViewController()
        controller.delegate = self
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.backgroundColor = UIColor.B5
        controller.view.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
        controller.view.corner(byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: 30)
        controller.setupLayout(type)
        
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: UIScreen.main.bounds.height)
        }
    }
    
    func presentWriteCommentView() {
        if commentIsComplete() {
            let controller = UIViewController()
            let writeCommentView: WriteCommentView = UIView.fromNib()
            writeCommentView.delegate = self
            controller.view = writeCommentView
            let name = stores.first { $0.storeID == comment.storeID }?.name ?? ""
            writeCommentView.layoutView(comment: comment, storeName: name)
            present(controller, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "提示", message: "你還沒有完成評論喔！", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    func commentIsComplete() -> Bool {
        if !comment.storeID.isEmpty && !comment.meal.isEmpty {
            return true
        }
        return false
    }
}
extension CommentSeletionController: SelectionViewDelegate {
    func didTapImageView(_ view: SeletionView, imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true)
    }
    func didFinishPickImage(_ view: SeletionView, image: UIImage, imagePicker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func selectStore(_ view: SeletionView, textField: UITextField) {
        initSecrchController()
    }
    
    func selectMeal(_ view: SeletionView, textField: UITextField, storeID: String) {
        initSecrchController(storeID: storeID)
    }
    
    func didTapSelectValue(_ view: SeletionView, type: SelectionType) {
        setupDraggingView(type)
    }
    
    func didTapWriteComment(_ view: SeletionView) {
        presentWriteCommentView()
    }
}
extension CommentSeletionController: SearchViewControllerDelegate {
    func didSelectedMeal(_ view: SearchViewController, meal: String) {
        selectionView.selectedMeal = meal
        comment.meal = meal
    }
    
    func didSelectedStore(_ view: SearchViewController, storeID content: String, name: String) {
        selectionView.selectedStoreID = content
        selectionView.selectedStoreName = name
        if comment.storeID != content {
            comment.meal = ""
            selectionView.selectedMealTextField.text = ""
        }
        comment.storeID = content
    }
    
    func postImageToStorge(viewController: UIViewController) {
        guard let image = imageDataHolder else { return }
        let fileName = "\(comment.userID)_\(Date())"
        LKProgressHUD.show()
        FirebaseStorageRequestProvider.shared.postImageToFirebaseStorage(data: image, fileName: fileName) { result in
            switch result {
            case .success(let url) :
                print("上傳圖片成功", url.description)
                self.comment.mainImage = url.description
                self.publishComment(viewController: viewController)
            case .failure(let error) :
                LKProgressHUD.dismiss()
                LKProgressHUD.showFailure(text: "再試一次")
                print("上傳圖片失敗", error)
            }
        }
    }
    func publishComment(viewController: UIViewController) {
        CommentRequestProvider.shared.publishComment(comment: &comment) { result in
            switch result {
            case .success:
                LKProgressHUD.dismiss()
                LKProgressHUD.showSuccess(text: "上傳評論成功")
                viewController.dismiss(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            case .failure:
                LKProgressHUD.dismiss()
                LKProgressHUD.showFailure(text: "再試一次")
            }
        }
    }
}
extension CommentSeletionController: WrireCommentViewControllerDelegate {
    
       
    func didTapSendComment(_ viewController: UIViewController, _ view: WriteCommentView, text: String) {
        comment.contenText = text
        postImageToStorge(viewController: viewController)
    }
    
    func didTapSaveDraft(_ viewController: UIViewController, _ view: WriteCommentView, text: String) {
        comment.contenText = text
        let image = imageDataHolder ?? Data()
        LKProgressHUD.show()
        StorageManager.shared.addDraftComment(comment: comment, image: image) { result in
            switch result {
            case .success:
                
                LKProgressHUD.dismiss()
                LKProgressHUD.showSuccess(text: "儲存草稿成功")
                viewController.dismiss(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            case .failure:
                LKProgressHUD.dismiss()
                LKProgressHUD.showFailure(text: "再試一次")
            }
        }
    }
}


extension CommentSeletionController: CommentDraggingViewDelegate {
    func didTapSendValue(_ viewController: DragingValueViewController, value: Double, type: SelectionType) {
        setValueToComment(type: type, value   : value)
        UIView.animate(withDuration: 0.5) {
            viewController.view.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
            self.navigationController?.navigationBar.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        
    }
    func setValueToComment(type: SelectionType, value: Double) {
        switch type {
        case .noodle:
            comment.contentValue.noodle = value
            let button = selectionView.selectNoodelValueButton
            button.initValueSubView(value: value, color: UIColor.main1)
        case .soup:
            comment.contentValue.soup = value
            let button = selectionView.selectSouplValueButton
            button.initValueSubView(value: value, color: UIColor.main2)
        case .happy:
            comment.contentValue.happiness = value
            let button = selectionView.selectOverAllValueButton
            button.initValueSubView(value: value, color: UIColor.main3)
        }
        if !comment.contentValue.happiness.isZero && !comment.contentValue.soup.isZero && !comment.contentValue.noodle.isZero {
            selectionView.showCommentButton()
        }
    }
}
