//
//  CommentSeletionController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/7.
//

import UIKit

class CommentSeletionController: UIViewController {
    
    var selectionView = SeletionView(frame: .zero)
    
    var mainImage: UIImage!
    var comment: Comment!
    var stores: [Store]!
    var draftData: CommentDraft!
    var isDraft = false
    // 上傳前的照片
    var imageDataHolder: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .B1
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configSeletionView()
    }
    init(userID: String, draft: CommentDraft, storeData: [Store]) {
        let imageData = draft.image ?? Data()
        let image = UIImage(data: imageData)
        self.mainImage = image
        imageDataHolder = imageData
        comment.userID = userID
        self.stores = storeData
        self.draftData = draft
        //        self.comment = comment
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
    func publishComment() {
        CommentRequestProvider.shared.publishComment(comment: &comment) { result in
            switch result {
            case let .success(message):
                print("上傳評論成功", message)
                LKProgressHUD.dismiss()
                LKProgressHUD.showSuccess(text: "上傳評論成功")
                //                self.sendButton.removeFromSuperview()
                //                self.fetchCommentOfUser {
                //                    self.setupStartingView()
                //                    self.commentData = self.originData
                //                }
            case let .failure(error):
                print("上傳評論失敗", error)
            }
        }
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
    
    func preSentWriteCommentView() {
        let controller = UIViewController()
        let writeCommentView: WriteCommentView = UIView.fromNib()
        writeCommentView.delegate = self
        controller.view = writeCommentView
        let name = stores.first { $0.storeID == comment.storeID }?.name ?? ""
        writeCommentView.layoutView(comment: comment, storeName: name)
        
        present(controller, animated: true, completion: nil)
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
        preSentWriteCommentView()
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
        }
        comment.storeID = content
    }
}
extension CommentSeletionController: WrireCommentViewControllerDelegate {
    func didTapSendComment(_ view: WriteCommentView, text: String, viewController: UIViewController) {
        viewController.dismiss(animated: true)
        
    }
    
    func didTapSaveDraft(_ view: WriteCommentView, text: String, viewController: UIViewController) {
        viewController.dismiss(animated: true)
        
    }
}
