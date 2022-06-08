//
//  CommentSeletionController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/7.
//

import UIKit

class CommentSeletionController: UIViewController {
    var imageCardView = CommentImageCardView()
        var selectionView = CommentSelectionView()
    var mainImage: UIImage!
    var comment: Comment!
    
    // 上傳前的照片
    var imageDataHolder: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    init(userID: String, draft: CommentDraft) {
        let imageData = draft.image ?? Data()
        let image = UIImage(data: imageData)
        self.mainImage = image
        imageDataHolder = imageData
        comment.userID = userID
//        self.comment = comment
    }
    
    init(userID: String, image: UIImage) {
        self.mainImage = image
        imageDataHolder = image.jpegData(compressionQuality: 0.1) ?? Data()
        self.comment = Comment(
            userID: userID,
            storeID: "",
            meal: "",
            contentValue: CommentContent(happiness: 5.0, noodle: 5.0, soup: 5.0),
            contenText: "",
            mainImage: ""
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
extension CommentSeletionController: SearchViewControllerDelegate {
    func didSelectedStore(_ view: SearchViewController, content: String) {
        selectionView.selectedStoreTextField.text = content
    }
}
extension CommentSeletionController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        commentImageView?.image = image
        delegate?.didFinishPickImage(self, imagePicker: picker)
    }
}
