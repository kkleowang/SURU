//
//  SendCommentConmViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/17.
//

import UIKit

class SendCommentConmViewController: UIViewController {
    let imageView = UIImageView()
    //    let StoreButton
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    func setupImageView() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.width).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1 ).isActive = true
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        //        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "fish1")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tab)
    }
    @objc func tapGesture(sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
}
extension SendCommentConmViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        dismiss(animated: true)
        
    }
}
