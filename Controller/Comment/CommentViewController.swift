//
//  SendCommentConmViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/17.
//

import UIKit
import SwiftUI

class CommentViewController: UIViewController {
    // View
    let startingView = CommentStartingView()
    
    let cardView = CommentCardView()
    
    let commentSelectionView = CommentSelectionView()
    
    // datasource放置
    var stores: [Store] = []
    
    var commentData: Comment = {
        let comment = Comment(
        userID: "ZBrsbRumZjvowPKfpFZL",
        storeID: "",
        meal: "",
        contentValue: CommentContent(happiness: 0, noodle: 0, soup: 0),
        contenText: "",
        mainImage: "")
        return comment
    }()
    
    // 上傳前的照片
    var imageDataHolder: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStoreData()
        setupStartingView()
    }
    
    func fetchStoreData() {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case .success(let data):
                self.stores = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupStartingView() {
        self.view.addSubview(startingView)
        startingView.translatesAutoresizingMaskIntoConstraints = false
        startingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        startingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        startingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        startingView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        startingView.commentTableView?.isHidden = false
        startingView.commentTableView?.delegate = self
        startingView.commentTableView?.dataSource = self
        startingView.delegate = self
        startingView.layoutStartingView()
    }
    
    func setupCardView(_ image: UIImage) {
        self.view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.clipsToBounds = true
        cardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        cardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 5 / 4).isActive = true
        cardView.commentImageView.image = image
        cardView.delegate = self
        cardView.layoutCommendCardView {
            setupCommentView()
        }
    }
    
    func setupLiqidViewController() {
        let controller = DragingValueViewController()
        controller.liquilBarview.delegate = self
        self.addChild(controller)
        view.addSubview(controller.view)
        controller.view.backgroundColor = UIColor.C5
        controller.view.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
        controller.view.corner(byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: 30)
        controller.selectionType = .noodle
        UIView.animate(withDuration: 0.5) {
            controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: UIScreen.main.bounds.height)
        }
    }
    func setupCommentView() {
        self.view.addSubview(commentSelectionView)
        commentSelectionView.delegate = self
        commentSelectionView.frame = CGRect(x: 20, y: UIScreen.height - 300, width: UIScreen.width - 40, height: 200)
//        commentSelectionView.layoutCommentSelectionView(dataSource: stores)
    }

    func publishComment() {
        CommentRequestProvider.shared.publishComment(comment: &commentData) { result in
            switch result {
            case .success(let message):
                print("上傳評論成功", message)
            case .failure(let error):
                print("上傳評論失敗", error)
            }
        }
    }
}
extension CommentViewController: SURUCommentStartingViewDelegate {
    func didTapImageView(_ view: CommentStartingView, imagePicker: UIImagePickerController?) {
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage) {
        setupCardView(image)
        imageDataHolder = image.jpegData(compressionQuality: 0.1) ?? Data()
        imagePicker.dismiss(animated: true) {
            view.removeFromSuperview()
        }
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "你的評論草稿"
        } else {
            return "你發表過的評論"
        }
    }
    
}

extension CommentViewController: SURUUserCommentInputDelegate {
    func didFinishPickImage(_ view: CommentCardView, imagePicker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func didTapImageView(_ view: CommentCardView) {
        present(view.imagePicker, animated: true, completion: nil)
    }
}
extension CommentViewController: CommentSelectionViewDelegate {
    func didGetSelectStore(_ view: CommentSelectionView, storeID: String) {
        print("didTapSelectNoodleValue")
    }
    
    func didGetSelectMeal(_ view: CommentSelectionView, meal: String) {
        print("didTapSelectNoodleValue")
    }
    
    func didTapSelectNoodleValue(_ view: CommentSelectionView) {
        print("didTapSelectNoodleValue")
    }
    
    func didTapSelectSoupValue(_ view: CommentSelectionView, type: SelectionType) {
        print("didTapSelectSoupValue", type.rawValue)
    }
    
    func didTapSelectHappyValue(_ view: CommentSelectionView) {
        print("didTapSelectHappyValue")
    }
    
    func didTapWriteComment(_ view: CommentSelectionView) {
        print("didTapWriteComment")
    }
    
    func didTapNotWriteComment(_ view: CommentSelectionView) {
        print("didTapNotWriteComment")
    }
    
    func didTapSendComment(_ view: CommentSelectionView) {
        guard let image = imageDataHolder else { return }
        let fileName = "\(commentData.userID)_\(Date())"
        FirebaseStorageRequestProvider.shared.postImageToFirebaseStorage(data: image, fileName: fileName) { result in
            switch result {
            case .success(let url) :
                print("上傳圖片成功", url.description)
                self.commentData.mainImage = url.description
                self.publishComment()
            case .failure(let error) :
                print("上傳圖片失敗", error)
            }
        }
    }
    
    func didTapSaveComment(_ view: CommentSelectionView) {
        print("didTapSaveComment")
    }
    
    func didTapDownloadImage(_ view: CommentSelectionView) {
        print("didTapDownloadImage")
    }
    
    func didTapAddoneMore(_ view: CommentSelectionView) {
        print("didTapAddoneMore")
    }
    
    func didTapGoAllPage(_ view: CommentSelectionView) {
        print("didTapGoAllPage")
    }
    
}
extension CommentViewController: SelectionValueManager {
    func getSelectionValue(type: SelectionType, value: Double) {
        switch type {
        case .noodle:
            commentData.contentValue.noodle = value
            print("MainPageGet noodel", value)
        case .soup:
            commentData.contentValue.soup = value
            print("MainPageGet soup", value)
        case .happy:
            commentData.contentValue.happiness = value
            print("MainPageGet happy", value)
        }
    }
}

