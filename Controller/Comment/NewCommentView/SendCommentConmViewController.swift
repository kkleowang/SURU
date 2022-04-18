//
//  SendCommentConmViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/17.
//

import UIKit
import SwiftUI

class SendCommentConmViewController: UIViewController {
    let startingView = CommentStartingView()
    let cardView = CommentCardView()
    let commentSelectionView = CommentSelectionView()
    var stores: [Store] = []
    var commentData: Comment = Comment(userID: "ZBrsbRumZjvowPKfpFZL", storeID: "", meal: "", contentValue: CommentContent(happiness: 0, noodle: 0, soup: 0), contenText: "", mainImage: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.B6
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        setupStartingView()
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
        commentSelectionView.layoutCommentSelectionView(dataSource: stores)
        
    }
    func fetchData() {
        FirebaseRequestProvider.shared.fetchStores { result in
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
        //        startingView.cornerForAll(radii: 30)
        startingView.translatesAutoresizingMaskIntoConstraints = false
        startingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        startingView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        startingView.heightAnchor.constraint(equalTo: startingView.widthAnchor, multiplier: 5/4).isActive = true
        //        startingView.cornerForAll(radii: 30)
        startingView.delegate = self
        startingView.layoutStartingView()
    }
    func setupCardView(_ image: UIImage) {
        self.view.addSubview(cardView)
        //        cardView.cornerForAll(radii: 40)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.clipsToBounds = true
        cardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        cardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 5 / 4).isActive = true
        cardView.commentImageView.image = image
        //        cardView.cornerForAll(radii: 40)
        cardView.delegate = self
        cardView.layoutCommendCardView() {
            setupCommentView()
        }
    }
}
extension SendCommentConmViewController: SURUCommentStartingViewDelegate {
    func didTapImageView(_ view: CommentStartingView, imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage) {
        setupCardView(image)
//        commentData.mainImage =
        imagePicker.dismiss(animated: true) {
            view.removeFromSuperview()
        }
    }
}

extension SendCommentConmViewController: SURUUserCommentInputDelegate {
    func didFinishPickImage(_ view: CommentCardView, imagePicker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func didTapImageView(_ view: CommentCardView) {
        present(view.imagePicker, animated: true, completion: nil)
    }
}
extension SendCommentConmViewController: SURUCommentSelectionViewDelegate {
    func didgetSelectedStore(_ view: CommentSelectionView, storeID: String) {
        commentData.storeID = storeID
        print("MainPageGet", storeID)
    }
    
    func didgetSelectedMeal(_ view: CommentSelectionView, meal: String) {
        commentData.meal = meal
        print("MainPageGet", meal)
    }
    
    func didgetSelectedComment(_ view: CommentSelectionView, comment: String) {
        commentData.contenText = comment
        print("MainPageGet", comment)
    }
    
    func didTapLikeView(_ view: CommentSelectionView) {
        setupLiqidViewController()
    }
}
extension SendCommentConmViewController: SelectionValueManager {
    func getSelectionValue(type: SelectionType, value: Int) {
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
