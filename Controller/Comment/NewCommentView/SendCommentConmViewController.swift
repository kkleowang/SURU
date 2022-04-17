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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupStartingView()
    }
    func setupStartingView() {
        self.view.addSubview(startingView)
        startingView.translatesAutoresizingMaskIntoConstraints = false
        startingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        startingView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        startingView.heightAnchor.constraint(equalTo: startingView.widthAnchor, multiplier: 5/4).isActive = true
        startingView.cornerForAll(radii: 30)
        startingView.delegate = self
        startingView.layoutStartingView()
    }
    func setupCardView(_ image: UIImage) {
        self.view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        cardView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 5/4).isActive = true
        cardView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        cardView.commentImageView.image = image
        cardView.cornerForAll(radii: 40)
        cardView.delegate = self
        cardView.layoutCommendCardView()
    }
}
extension SendCommentConmViewController: SURUCommentStartingViewDelegate {
    func didTapImageView(_ view: CommentStartingView, imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage) {
        setupCardView(image)
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
