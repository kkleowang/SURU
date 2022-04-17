//
//  CommentCardView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit

protocol SURUUserCommentInputDelegate: AnyObject {
    
    func didTapImageView(_ view: CommentCardView)
    func didFinishPickImage(_ view: CommentCardView, imagePicker: UIImagePickerController)
    
}
class CommentCardView: UIView {
    let commentImageView = UIImageView()
    let commentDescriptionView = UIView()
    var storeNameLabel = UILabel()
    var mealNameLabel = UILabel()
    var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }()
    weak var delegate: SURUUserCommentInputDelegate?
    
    func layoutCommendCardView() {
        layoutCommentImageView()
        layoutCommentDescriptionView()
    }
    private func layoutCommentDescriptionView() {
        self.addSubview(commentDescriptionView)
        self.addSubview(storeNameLabel)
        self.addSubview(mealNameLabel)
        commentDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        commentDescriptionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        commentDescriptionView.heightAnchor.constraint(equalTo: commentDescriptionView.widthAnchor, multiplier: 270/1080 ).isActive = true
        commentDescriptionView.topAnchor.constraint(equalTo: self.commentImageView.bottomAnchor).isActive = true
        commentDescriptionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        commentDescriptionView.corner(byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radii: 25)
        commentDescriptionView.backgroundColor = .blue
        
        storeNameLabel.font = UIFont.medium(size: 30)
        mealNameLabel.font = UIFont.medium(size: 15)
        storeNameLabel.textColor = UIColor.B1
        mealNameLabel.textColor = UIColor.B1
        storeNameLabel.topAnchor.constraint(equalTo: commentDescriptionView.topAnchor, constant: 16).isActive = true
        storeNameLabel.leadingAnchor.constraint(equalTo: commentDescriptionView.leadingAnchor,constant: 8).isActive = true
        mealNameLabel.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 8).isActive = true
        mealNameLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor).isActive = true
        storeNameLabel.text = "123"
        mealNameLabel.text = "456"
    }
    
    private func layoutCommentImageView() {
        self.addSubview(commentImageView)
        commentImageView.translatesAutoresizingMaskIntoConstraints = false
        commentImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        commentImageView.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        commentImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        commentImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        commentImageView.contentMode = .scaleAspectFit
        // placeHolder
//        commentImageView.image = UIImage(named: "DDD")
        commentImageView.isUserInteractionEnabled = true
        // setgesture
        let tab = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        commentImageView.addGestureRecognizer(tab)
    }
    @objc func tapGesture(sender: UITapGestureRecognizer) {
        imagePicker.delegate = self
        self.delegate?.didTapImageView(self)
    }
}
extension CommentCardView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        commentImageView.image = image
        self.delegate?.didFinishPickImage(self, imagePicker: picker)
    }
}
