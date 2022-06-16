//
//  EditProfileView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/5.
//

import Kingfisher
import UIKit

protocol EditProfileViewDelegate: AnyObject {
    func didSelectImage(_ view: EditProfileView, image: UIImage)
    func didSelectImage(_ view: EditProfileView, image: UIImage, imagePickView: UIImagePickerController)
    func didTapImagePicker(_ view: EditProfileView, imagePicker: UIImagePickerController?)
    func didEditNickName(_ view: EditProfileView, text: String)
    func didEditWebSide(_ view: EditProfileView, text: String)
    func didEditBio(_ view: EditProfileView, text: String)
    func didTapEditImage(_ view: EditProfileView, alert: UIAlertController)
}

class EditProfileView: UIView {
    weak var delegate: EditProfileViewDelegate?

    //    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var websideLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    func endEditing() {
        nickNameTextfield.resignFirstResponder()
        websideTextField.resignFirstResponder()
        bioTextView.resignFirstResponder()
    }
    @IBOutlet var nickNameTextfield: UITextField!
    @IBOutlet var websideTextField: UITextField!
    @IBOutlet var bioTextView: UITextView!

    @IBOutlet var mainImageView: UIImageView!

    @IBOutlet var editImageButton: UIButton!
    var imagePicker: UIImagePickerController? {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        return imagePicker
    }

    @IBAction func tapEditImageButton(_: UIButton) {
        showAlert()
    }

    func layoutView(currentUser: Account) {
        mainImageView.kf.setImage(with: URL(string: currentUser.mainImage))
        mainImageView.layer.cornerRadius = 40
        mainImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        mainImageView.addGestureRecognizer(tap)
        nickNameTextfield.text = currentUser.name
        nickNameTextfield.delegate = self
        websideTextField.delegate = self
        bioTextView.delegate = self
        if let webSide = currentUser.websideLink {
            websideTextField.text = webSide
        }
        if let bio = currentUser.bio {
            bioTextView.text = bio
        }
    }

    @objc func tapImage() {
        showAlert()
    }

    private func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }

    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "移除目前的大頭貼照", style: .default, handler: { _ in
            LKProgressHUD.showSuccess(text: "修改成功")
            guard let image = UIImage(named: "mainImage") else { return }
            self.mainImageView.image = image
            self.delegate?.didSelectImage(self, image: image)
        }))
        alert.addAction(UIAlertAction(title: "從圖庫選擇", style: .default, handler: { _ in
            self.delegate?.didTapImagePicker(self, imagePicker: self.imagePicker)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            print("User click Dismiss button")
        }))
        delegate?.didTapEditImage(self, alert: alert)
    }
}

extension EditProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        mainImageView.image = image
        delegate?.didSelectImage(self, image: image, imagePickView: picker)
    }
}

extension EditProfileView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didEditBio(self, text: textView.text)
    }
}

extension EditProfileView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == websideTextField {
            if !verifyUrl(urlString: textField.text) {
                textField.textColor = .red
                delegate?.didEditWebSide(self, text: "無效網址")
            } else {
                if #available(iOS 15.0, *) {
                    textField.textColor = .tintColor
                    self.delegate?.didEditWebSide(self, text: textField.text ?? "")
                } else {
                    textField.textColor = .blue
                    delegate?.didEditWebSide(self, text: textField.text ?? "")
                }
            }
        } else {
            delegate?.didEditNickName(self, text: textField.text ?? "")
        }
    }
}
