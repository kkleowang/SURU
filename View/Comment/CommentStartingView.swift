//
//  CommentStartingView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit

protocol SURUCommentStartingViewDelegate: AnyObject {
    func didTapImageView(_ view: CommentStartingView, imagePicker: UIImagePickerController)
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage)
}
class CommentStartingView: UIView {

    weak var delegate: SURUCommentStartingViewDelegate?
    let startButton = UIButton()

    func layoutStartingView() {
        self.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        startButton.layer.borderColor = UIColor.B1?.cgColor
        startButton.layer.borderWidth = 1
        startButton.layer.cornerRadius = 15
//        startButton.backgroundColor = .black.withAlphaComponent(0.7)
        startButton.setTitle("開始評論", for: .normal)
        startButton.setTitleColor(.B1, for: .normal)
        startButton.addTarget(self, action: #selector(startComment), for: .touchUpInside)
        
    }
    
    @objc func startComment() {
        let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
        self.delegate?.didTapImageView(self, imagePicker: imagePicker)
    }
}
extension CommentStartingView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.delegate?.didFinishPickImage(self, imagePicker: picker, image: image)
    }
}
