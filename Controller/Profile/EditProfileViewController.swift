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
    var userData: Account? {
        didSet {
            guard let userData = userData else { return }
            editProfileView.layoutView(currentUser: userData)
            self.view.stickSubView(editProfileView)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfileView.delegate = self
        settingNavBtn()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func settingNavBtn() {
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancel))
        leftItem.tintColor = .B2
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(save))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
        LKProgressHUD.showSuccess(text: "取消編輯")
    }
    @objc func save() {
        
    }
    
}
extension EditProfileViewController: EditProfileViewDelegate {
    func didSelectImage(_ view: EditProfileView, image: UIImage) {
        mainImage = image
        LKProgressHUD.showSuccess(text: "刪除成功")
    }
    
    func didTapEditImage(_ view: EditProfileView, alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func didSelectImage(_ view: EditProfileView, image: UIImage, imagePickView: UIImagePickerController) {
        mainImage = image
        imagePickView.dismiss(animated: true) {
            LKProgressHUD.showSuccess(text: "上傳成功")
        }
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
