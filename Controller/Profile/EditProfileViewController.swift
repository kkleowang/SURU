//
//  EditProfileViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/5.
//

import UIKit

class EditProfileViewController: UIViewController {
    var mainImage = UIImage()
    var nickName = ""
    var bio = ""
    var webside = ""
    
    let editProfileView: EditProfileView = UIView.fromNib()
    var userData: Account?
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfileView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
extension EditProfileViewController: EditProfileViewDelegate {
    func didTapEditImage(_ view: EditProfileView, alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func didSelectImage(_ view: EditProfileView, image: UIImage) {
        mainImage = image
    }
    
    func didTapImagePicker(_ view: EditProfileView, imagePicker: UIImagePickerController?) {
        guard let imagePicker = imagePicker else { return }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didEditNickName(_ view: EditProfileView, text: String) {
        nickName = text
    }
    
    func didEditWebSide(_ view: EditProfileView, text: String) {
        webside = text
    }
    
    func didEditBio(_ view: EditProfileView, text: String) {
        bio = text
    }
    
    
}
