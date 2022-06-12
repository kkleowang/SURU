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
    case writeComment = "writeComment"
}

protocol SelectionViewDelegate: AnyObject {
    func didTapImageView(_ view: SeletionView, imagePicker: UIImagePickerController)
    func didFinishPickImage(_ view: SeletionView, image: UIImage, imagePicker: UIImagePickerController)
    
    func selectStore(_ view: SeletionView, textField: UITextField)
    func selectMeal(_ view: SeletionView, textField: UITextField, storeID: String)
    
    func didTapSelectValue(_ view: SeletionView, type: SelectionType)
    
    func didTapWriteComment(_ view: SeletionView)
}
class SeletionView: UIView {
    weak var delegate: SelectionViewDelegate?
    var selectedStoreName: String! {
        willSet {
            selectedStoreTextField.text = newValue
        }
    }
    var selectedStoreID: String! {
        willSet {
            selectedMealTextField.isHidden = false
        }
    }
    var selectedMeal: String! {
        willSet {
            selectedMealTextField.text = newValue
            self.setupButtons()
            self.setupLabels()
            showOtherSelection()
        }
    }
    
    let imageView = UIImageView()
    let imagePicker = UIImagePickerController()
    
    var selectedStoreTextField = UITextField()
    var selectedMealTextField = UITextField()
    
    let selectionBackgroundView = UIView()
    let stackView = UIStackView()
    
    let selectNoodelValueButton = UIButton()
    let selectSouplValueButton = UIButton()
    let selectOverAllValueButton = UIButton()
    
    let noodleLabel = UILabel()
    let soupLabel = UILabel()
    let overallLabel = UILabel()
    let writeCommentLabel = UILabel()
    
    let writeCommentButton = UIButton()
    
    func configView(image: UIImage) {
        imageView.image = image
        
        backgroundColor = .white
    }
    init(frame: CGRect, topBarHeight: CGFloat) {
        super.init(frame: frame)
        self.topBarHeight = topBarHeight
        self.setupImageView()
        self.setupBackgroundView()
        self.setupTextField()
    }
    var topBarHeight: CGFloat!
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupImageView() {
        addSubview(imageView)
        imageView.cornerRadii(radii: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.width - 32).isActive = true
        imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: topBarHeight).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imageView.addGestureRecognizer(tap)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    func setupBackgroundView() {
        addSubview(selectionBackgroundView)
        selectionBackgroundView.backgroundColor = .C2
        selectionBackgroundView.cornerRadii(radii: 10)
        selectionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        selectionBackgroundView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        selectionBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        selectionBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        selectionBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIDevice.current.bottomSafeAreaHeight - 8).isActive = true
        selectionBackgroundView.makeShadow(offset: CGSize(width: 3, height: 3))
    }
    
    func setupTextField() {
        selectionBackgroundView.addSubview(selectedStoreTextField)
        selectedStoreTextField.delegate = self
        selectedStoreTextField.translatesAutoresizingMaskIntoConstraints = false
        selectedStoreTextField.backgroundColor = .B6
        selectedStoreTextField.text = "點擊選取店家"
        selectedStoreTextField.textColor = .B1
        selectedStoreTextField.topAnchor.constraint(equalTo: selectionBackgroundView.topAnchor, constant: 8).isActive = true
        selectedStoreTextField.leadingAnchor.constraint(equalTo: selectionBackgroundView.leadingAnchor, constant: 8).isActive = true
        selectedStoreTextField.font = UIFont.medium(size: 24)
        
        selectedStoreTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        selectedStoreTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        //        bringSubviewToFront(selectedStoreTextField)
        
        selectionBackgroundView.addSubview(selectedMealTextField)
        selectedMealTextField.delegate = self
        
        selectedMealTextField.translatesAutoresizingMaskIntoConstraints = false
        selectedMealTextField.backgroundColor = .B6
        selectedMealTextField.text = "點擊選取品項"
        selectedMealTextField.textColor = .B1
        selectedStoreTextField.font = UIFont.medium(size: 20)
        selectedMealTextField.topAnchor.constraint(equalTo: selectedStoreTextField.bottomAnchor, constant: 8).isActive = true
        selectedMealTextField.leadingAnchor.constraint(equalTo: selectedStoreTextField.leadingAnchor, constant: 0).isActive = true
        selectedMealTextField.isHidden = true
        selectedMealTextField.borderStyle = UITextField.BorderStyle.roundedRect
        selectedMealTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        //        bringSubviewToFront(selectedMealTextField)
    }
    
    func setupButtons() {
        selectionBackgroundView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        var height: CGFloat {
            let number = selectionBackgroundView.bounds.height - selectedStoreTextField.bounds.height - selectedMealTextField.bounds.height - 16 - 8 - 24
            if number > 50 {
                return 50
            } else {
                return number
            }
        }
        stackView.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.leadingAnchor.constraint(equalTo: selectionBackgroundView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: selectionBackgroundView.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: selectionBackgroundView.bottomAnchor, constant: -24).isActive = true
        stackView.addArrangedSubview(selectNoodelValueButton)
        stackView.addArrangedSubview(selectSouplValueButton)
        stackView.addArrangedSubview(selectOverAllValueButton)
        stackView.addArrangedSubview(writeCommentButton)
        stackView.isHidden = true
        
        selectNoodelValueButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectNoodelValueButton.heightAnchor.constraint(equalTo: selectNoodelValueButton.widthAnchor, multiplier: 1).isActive = true
        selectNoodelValueButton.layer.cornerRadius = 15
        selectNoodelValueButton.setImage(UIImage(named: SelectionButton.selectNoodle.rawValue), for: .normal)
        selectNoodelValueButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectNoodelValueButton.backgroundColor = .black.withAlphaComponent(0.4)
        selectNoodelValueButton.tintColor = .white
        selectNoodelValueButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        selectSouplValueButton.translatesAutoresizingMaskIntoConstraints = false
        selectSouplValueButton.heightAnchor.constraint(equalTo: selectSouplValueButton.widthAnchor, multiplier: 1).isActive = true
        selectSouplValueButton.layer.cornerRadius = 15
        selectSouplValueButton.setImage(UIImage(named: SelectionButton.selectSoup.rawValue), for: .normal)
        selectSouplValueButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectSouplValueButton.backgroundColor = .black.withAlphaComponent(0.4)
        selectSouplValueButton.tintColor = .white
        selectSouplValueButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        selectOverAllValueButton.translatesAutoresizingMaskIntoConstraints = false
        selectOverAllValueButton.heightAnchor.constraint(equalTo: selectOverAllValueButton.widthAnchor, multiplier: 1).isActive = true
        selectOverAllValueButton.layer.cornerRadius = 15
        selectOverAllValueButton.setImage(UIImage(named: SelectionButton.selectHappy.rawValue), for: .normal)
        selectOverAllValueButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectOverAllValueButton.backgroundColor = .black.withAlphaComponent(0.4)
        selectOverAllValueButton.tintColor = .white
        selectOverAllValueButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        writeCommentButton.translatesAutoresizingMaskIntoConstraints = false
        writeCommentButton.heightAnchor.constraint(equalTo: writeCommentButton.widthAnchor, multiplier: 1).isActive = true
        writeCommentButton.layer.cornerRadius = 15
        writeCommentButton.setImage(UIImage(named: SelectionButton.writeComment.rawValue), for: .normal)
        writeCommentButton.addTarget(self, action: #selector(writeComment), for: .touchUpInside)
        writeCommentButton.backgroundColor = .black.withAlphaComponent(0.4)
        writeCommentButton.tintColor = .white
        writeCommentButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        writeCommentButton.isHidden = true
    }
    func setupLabels() {
        selectionBackgroundView.addSubview(noodleLabel)
        noodleLabel.translatesAutoresizingMaskIntoConstraints = false
        noodleLabel.topAnchor.constraint(equalTo: selectNoodelValueButton.bottomAnchor, constant: 4).isActive = true
        noodleLabel.centerXAnchor.constraint(equalTo: selectNoodelValueButton.centerXAnchor, constant: 0).isActive = true
        noodleLabel.font = .medium(size: 12)
        noodleLabel.tintColor = .B1
        noodleLabel.text = "麵條評分"
        noodleLabel.isHidden = true
        
        selectionBackgroundView.addSubview(soupLabel)
        soupLabel.translatesAutoresizingMaskIntoConstraints = false
        soupLabel.topAnchor.constraint(equalTo: selectSouplValueButton.bottomAnchor, constant: 4).isActive = true
        soupLabel.centerXAnchor.constraint(equalTo: selectSouplValueButton.centerXAnchor, constant: 0).isActive = true
        soupLabel.font = .medium(size: 12)
        soupLabel.tintColor = .B1
        soupLabel.text = "湯頭評分"
        soupLabel.isHidden = true
        
        selectionBackgroundView.addSubview(overallLabel)
        overallLabel.translatesAutoresizingMaskIntoConstraints = false
        overallLabel.topAnchor.constraint(equalTo: selectOverAllValueButton.bottomAnchor, constant: 4).isActive = true
        overallLabel.centerXAnchor.constraint(equalTo: selectOverAllValueButton.centerXAnchor, constant: 0).isActive = true
        overallLabel.font = .medium(size: 12)
        overallLabel.tintColor = .B1
        overallLabel.text = "綜合評分"
        overallLabel.isHidden = true
        
        selectionBackgroundView.addSubview(writeCommentLabel)
        writeCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        writeCommentLabel.topAnchor.constraint(equalTo: writeCommentButton.bottomAnchor, constant: 4).isActive = true
        writeCommentLabel.centerXAnchor.constraint(equalTo: writeCommentButton.centerXAnchor, constant: 0).isActive = true
        writeCommentLabel.font = .medium(size: 12)
        writeCommentLabel.tintColor = .B1
        writeCommentLabel.text = "完成評論"
        writeCommentLabel.isHidden = true
    }
    func showOtherSelection() {
        stackView.isHidden = false
        noodleLabel.isHidden = false
        soupLabel.isHidden = false
        overallLabel.isHidden = false
    }
    func showCommentButton() {
        writeCommentButton.isHidden = false
        writeCommentLabel.isHidden = false
        UIView.animate(withDuration: 0.8) {
            self.layoutIfNeeded()
        }
    }
    
    
    @objc func tapImage() {
        delegate?.didTapImageView(self, imagePicker: imagePicker)
    }
    
    @objc func selectValue(sender: UIButton) {
        let type: SelectionType = {
            switch sender {
            case selectNoodelValueButton:
                return SelectionType.noodle
            case selectSouplValueButton:
                return SelectionType.soup
            case selectOverAllValueButton:
                return SelectionType.happy
            default:
                return SelectionType.noodle
            }
        }()
        delegate?.didTapSelectValue(self, type: type)
    }
    @objc func selectValueFromView(sender: UIView) {
        let type: SelectionType = {
            switch sender.backgroundColor {
            case UIColor.main1:
                return SelectionType.noodle
            case UIColor.main2:
                return SelectionType.soup
            case UIColor.main3:
                return SelectionType.happy
            default:
                return SelectionType.noodle
            }
        }()
        delegate?.didTapSelectValue(self, type: type)
    }
    @objc func writeComment() {
        delegate?.didTapWriteComment(self)
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
            self.delegate?.selectStore(self, textField: textField)
        } else {
            if selectedStoreID != nil {
                self.delegate?.selectMeal(self, textField: textField, storeID: selectedStoreID)
            }
        }
        return false
    }
}
