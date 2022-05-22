//
//  CommentCardView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit

protocol CommentImageCardViewDelegate: AnyObject {
    func didTapImageView(_ view: CommentImageCardView)

    func didFinishPickImage(_ view: CommentImageCardView, imagePicker: UIImagePickerController)
}

class CommentImageCardView: UIView {
    weak var delegate: CommentImageCardViewDelegate?

    var commentImageView: UIImageView? {
        let imageView = UIImageView()
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill

        imageView.isUserInteractionEnabled = true
        let tab = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        imageView.addGestureRecognizer(tab)
        return imageView
    }

    var imagePicker: UIImagePickerController? {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }

    func layoutCommendCardView(image: UIImage, completion: @escaping () -> Void) {
        layer.cornerRadius = 10
        clipsToBounds = true
        commentImageView?.image = image
        completion()
    }

    @objc func tapGesture(sender _: UITapGestureRecognizer) {
        delegate?.didTapImageView(self)
    }
}

extension CommentImageCardView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        commentImageView?.image = image
        delegate?.didFinishPickImage(self, imagePicker: picker)
    }
}
