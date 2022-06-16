//
//  EditProfileViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/5.
//

import CHTCollectionViewWaterfallLayout
import UIKit

class EditProfileViewController: UIViewController {
    var mainImage = UIImage()
    var nickName = ""
    var bio = ""
    var webside = ""
    var image = ""
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
        mappingUserData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor  = .B1
        navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func settingNavBtn() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func mappingUserData() {
        guard let userData = userData else { return }
        nickName = userData.name
        bio = userData.bio ?? ""
        webside = userData.websideLink ?? ""
        image = userData.mainImage
    }

    @objc func save() {
        editProfileView.endEditing()
        guard let userData = userData else { return }
        if image == userData.mainImage {
            let type = ["name", "bio", "websideLink", "mainImage"]
            let content = [nickName, bio, webside, image]
            AccountRequestProvider.shared.updateDataAccount(currentUserID: userData.userID, type: type, content: content)
            
        LKProgressHUD.showSuccess(text: "更新成功")
            navigationController?.popToRootViewController(animated: true)
            
        } else {
            uploadImage {
                let type = ["name", "bio", "websideLink", "mainImage"]
                let content = [self.nickName, self.bio, self.webside, self.image]
                AccountRequestProvider.shared.updateDataAccount(currentUserID: userData.userID, type: type, content: content)

                self.dismiss(animated: true) {
                    LKProgressHUD.showSuccess(text: "更新成功")
                }
            }
        }
    }

    private func uploadImage(com: @escaping () -> Void) {
        guard let userData = userData else { return }
        guard let image = mainImage.jpegData(compressionQuality: 0.1) else { return }
        let fileName = "\(userData.userID)_\(Date())"
        LKProgressHUD.show()
        FirebaseStorageRequestProvider.shared.postImageToFirebaseStorage(data: image, fileName: fileName) { result in
            switch result {
            case let .success(url):
                LKProgressHUD.dismiss()
                LKProgressHUD.showSuccess(text: "上傳圖片成功")
                print("上傳圖片成功", url.description)
                self.image = url.description
            case let .failure(error):
                LKProgressHUD.dismiss()
                LKProgressHUD.showFailure(text: "上傳圖片失敗")
                print("上傳圖片失敗", error)
            }
            com()
        }
    }
}

extension EditProfileViewController: EditProfileViewDelegate {
    func didSelectImage(_: EditProfileView, image: UIImage) {
        mainImage = image
        LKProgressHUD.showSuccess(text: "刪除成功")
    }

    func didTapEditImage(_: EditProfileView, alert: UIAlertController) {
        alert.popoverPresentationController?.sourceView = view

        let xOrigin = view.bounds.width / 2

        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)

        alert.popoverPresentationController?.sourceRect = popoverRect

        alert.popoverPresentationController?.permittedArrowDirections = .up
        present(alert, animated: true, completion: nil)
    }

    func didSelectImage(_: EditProfileView, image: UIImage, imagePickView: UIImagePickerController) {
        mainImage = image
        imagePickView.dismiss(animated: true) {
            LKProgressHUD.showSuccess(text: "上傳成功")
        }
    }

    func didTapImagePicker(_: EditProfileView, imagePicker: UIImagePickerController?) {
        guard let imagePicker = imagePicker else { return }
        present(imagePicker, animated: true, completion: nil)
    }

    func didEditNickName(_: EditProfileView, text: String) {
        nickName = text
    }

    func didEditWebSide(_: EditProfileView, text: String) {
        webside = text
    }

    func didEditBio(_: EditProfileView, text: String) {
        bio = text
    }
}
