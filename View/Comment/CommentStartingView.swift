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

    var startCommentButton: UIButton? {
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

    var commentTableView = UITableView()

    var imagePicker: UIImagePickerController? {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        return imagePicker
    }

    func layoutStartingView() {
        addSubview(commentTableView)
        commentTableView.register(UINib(nibName: String(describing: CommentTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CommentTableViewCell.self))
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        commentTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        commentTableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        commentTableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        startCommentButton?.isHidden = false
    }

    @objc func startComment(_: UIButton) {
        //        sender.isHidden = true
        delegate?.didTapImageView(self, imagePicker: imagePicker)
    }
}

extension CommentStartingView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        delegate?.didFinishPickImage(self, imagePicker: picker, image: image)
    }
}
