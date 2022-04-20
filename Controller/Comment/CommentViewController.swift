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
    
    let imageCardView = CommentImageCardView()
    
    let selectionView = CommentSelectionView()
    
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
    
    func setupImageCardView(_ image: UIImage) {
        self.view.addSubview(imageCardView)
        imageCardView.translatesAutoresizingMaskIntoConstraints = false
        imageCardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        imageCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        imageCardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        imageCardView.heightAnchor.constraint(equalTo: imageCardView.widthAnchor, multiplier: 5 / 4).isActive = true
        imageCardView.delegate = self
        imageCardView.layoutCommendCardView(image: image) { [weak self] in
            guard let self = self else { return }
            self.setupCommentSelectionView()
        }
    }
    
    func setupCommentSelectionView() {
        self.view.addSubview(selectionView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.delegate = self
        selectionView.backgroundColor = .red
        selectionView.topAnchor.constraint(equalTo: self.imageCardView.bottomAnchor, constant: -100).isActive = true
        selectionView.leadingAnchor.constraint(equalTo: self.imageCardView.leadingAnchor, constant: 10).isActive = true
        selectionView.trailingAnchor.constraint(equalTo: self.imageCardView.trailingAnchor, constant: -10).isActive = true
        selectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        selectionView.layoutSelectView(dataSource: stores)
    }
    
    func setupDraggingView(_ type: SelectionType) {
        let draggingView = CommentDraggingView()
        view.addSubview(draggingView)
        draggingView.delegate = self
        draggingView.translatesAutoresizingMaskIntoConstraints = false
       
        draggingView.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
        draggingView.corner(byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: 30)
        draggingView.layoutDraggingView(type: type)
        UIView.animate(withDuration: 0.5) {
            draggingView.frame = CGRect(x: 0, y: 0, width: 300, height: UIScreen.main.bounds.height)
        }
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

// StartingView Delegate
extension CommentViewController: CommentStartingViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func didTapImageView(_ view: CommentStartingView, imagePicker: UIImagePickerController?) {
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage) {
        setupImageCardView(image)
        imageDataHolder = image.jpegData(compressionQuality: 0.1) ?? Data()
        imagePicker.dismiss(animated: true) {
            view.removeFromSuperview()
        }
    }
    // TableView
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

// CommentImageCardView Delegate
extension CommentViewController: CommentImageCardViewDelegate {
    func didFinishPickImage(_ view: CommentImageCardView, imagePicker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func didTapImageView(_ view: CommentImageCardView) {
        guard let imagePicker = view.imagePicker else { return }
        present(imagePicker, animated: true, completion: nil)
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
        setupDraggingView(.noodle)
    }
    
    func didTapSelectSoupValue(_ view: CommentSelectionView, type: SelectionType) {
        setupDraggingView(.soup)
    }
    
    func didTapSelectHappyValue(_ view: CommentSelectionView) {
        setupDraggingView(.happy)
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


extension CommentViewController: CommentDraggingViewDelegate {
    func didGetSelectionValue(view: CommentDraggingView, type: SelectionType, value: Double) {
        print("didTapGoAllPage")
    }
    
    func didTapBackButton(view: CommentDraggingView) {
        print("didTapGoAllPage")
    }
}

