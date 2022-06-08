//
//  SeletionView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/7.
//

import UIKit

enum SelectionButton: String {
    case addPicture = "addMedia"
    case selectNoodle = "noodle"
    case selectSoup = "water"
    case selectHappy = "thumb"
    case notWriteComment = "notwriteComment"
    case saveCommentToDraft = "draftmark"
    case downloadPicture = "download"
    case backToCommentPage = "back"
    case addAnotherOne = "goPage"
}

protocol SelectionViewDelegate: AnyObject {
    
    func didTapStoreSelection(_ view: SeletionViews) //
    func didTapMealSelection(_ view: SeletionView, storeID: String) //
    
    func didTapSelectValue(_ view: SeletionView, type: SelectionType)

    func didTapWriteComment(_ view: SeletionView)

    func didTapSendComment(_ view: SeletionView)

    func didTapSaveComment(_ view: SeletionView)
    
    func didTapImageView(_ view: SeletionView, imagePicker: UIImagePickerController) //
    func didFinishPickImage(_ view: SeletionView, image: UIImage, imagePicker: UIImagePickerController) //
}
class SeletionView: UIView {
    weak var delegate: SelectionViewDelegate?
    
    var selectedStoreID: String! {
        didSet {
            selectedStoreID
        }
    }
    var stores: [Store]!
    init(stores: [Store]) {
        super.init(frame: .zero)
        self.stores = stores
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView = UIImageView()
    let imagePicker = UIImagePickerController()
    
    var selectedStoreTextField = UITextField()
    var selectedMealTextField = UITextField()
    let writeCommentButton = UIButton()
    let buttonStackView = UIStackView()
    
    
    func setupTextField() {
        addSubview(selectedStoreTextField)
        selectedStoreTextField.delegate = self
        selectedStoreTextField.translatesAutoresizingMaskIntoConstraints = false
        selectedStoreTextField.backgroundColor = .B6
        selectedStoreTextField.text = "點擊選取店家"
        selectedStoreTextField.textColor = .B1
        selectedStoreTextField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        selectedStoreTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        selectedStoreTextField.font = UIFont.medium(size: 30)
        selectedStoreTextField.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        selectedStoreTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true

        addSubview(selectedMealTextField)
        selectedMealTextField.translatesAutoresizingMaskIntoConstraints = false
        selectedMealTextField.backgroundColor = .B6
        selectedMealTextField.text = "點擊選取品項"
        selectedMealTextField.textColor = .B1
        selectedMealTextField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        selectedMealTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        selectedStoreTextField.font = UIFont.medium(size: 20)
        selectedMealTextField.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        selectedMealTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
    }
    func setupImageView() {
        addSubview(imageView)
        imageView.cornerRadii(radii: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.width - 32).isActive = true
        imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        imageView.contentMode = .scaleAspectFill

        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imageView.addGestureRecognizer(tap)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    @objc func tapImage() {
        delegate?.didTapImageView(self, imagePicker: imagePicker)
    }
}

extension SeletionView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        delegate?.didFinishPickImage(self, image: image, imagePicker: picker)
    }
}

extension SeletionView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectedStoreTextField {
            self.delegate?.didTapStoreSelection(self)
        } else {
            self.delegate?.didTapMealSelection(self, storeID: selectedStoreID)
        }
        return false
    }
    func pushSearchController(storeID: String?) {
        let controller = SearchViewController()
        controller.delegate = self
        
        selectedStoreID
    }
}
