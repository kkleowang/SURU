//
//  CommentStartingView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit

protocol CommentStartingViewDelegate: AnyObject {
    func didTapImageView(_ view: CommentStartingView, imagePicker: UIImagePickerController?)
    
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage)
}

class CommentStartingView: UIView {
    weak var delegate: CommentStartingViewDelegate?
    var commentTableView = UITableView()
    
    var startCommentButton: UIButton! {
        let button = UIButton()
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: SelectionButton.addPicture.rawValue), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 30
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        button.backgroundColor = .black.withAlphaComponent(0.4)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addTarget(self, action: #selector(startComment), for: .touchUpInside)
        return button
    }
    var imagePicker: UIImagePickerController? {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        return imagePicker
    }
    
    func layoutStartingView() {
        addSubview(commentTableView)
        commentTableView.registerCellWithNib(identifier: CommentTableViewCell.identifier, bundle: nil)
        stickSubView(commentTableView)
        addSubview(startCommentButton)
    }
    
    @objc func startComment(_: UIButton) {
        delegate?.didTapImageView(self, imagePicker: imagePicker)
    }
}

extension CommentStartingView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            delegate?.didFinishPickImage(self, imagePicker: picker, image: image)
        }
    }
}
