//
//  CommentSelectionView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit
import Alamofire


protocol CommentSelectionViewDelegate: AnyObject {
    func didGetSelectStore(_ view: CommentSelectionView, storeID: String)
    
    func didGetSelectMeal(_ view: CommentSelectionView, meal: String)
    
    func didTapSelectNoodleValue(_ view: CommentSelectionView)
    
    func didTapSelectSoupValue(_ view: CommentSelectionView, type: SelectionType)
    
    func didTapSelectHappyValue(_ view: CommentSelectionView)
    
    func didTapWriteComment(_ view: CommentSelectionView)
    
    func didTapNotWriteComment(_ view: CommentSelectionView)
    
    func didTapSendComment(_ view: CommentSelectionView)
    
    func didTapSaveComment(_ view: CommentSelectionView)
    
    func didTapDownloadImage(_ view: CommentSelectionView)
    
    func didTapAddoneMore(_ view: CommentSelectionView)
    
    func didTapGoAllPage(_ view: CommentSelectionView)
}
// 素材名稱
enum SelectionButton: String {
    case addPicture = "addMedia"
    case selectStore = "store"
    case selectMeal = "noodle"
    case selectValue = "favorite"
    case writeComment = "writeComment"
    case notWriteComment = "notwriteComment"
    case saveCommentToDraft = "draftmark"
    case downloadPicture = "download"
    case backToCommentPage = "back"
    case addAnotherOne = "goPage"
}

class CommentSelectionView: UIView {
    weak var delegate: CommentSelectionViewDelegate?
    var selectedStoreID: String = ""
    var stores: [Store] = []
    
    
    // MARK: - 選取店家物件
    var selectedStoreTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.widthAnchor.constraint(equalToConstant: UIScreen.width).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return textField
    }()
    
    var selectedMealTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.widthAnchor.constraint(equalToConstant: UIScreen.width).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 15).isActive = true
        return textField
    }()
    
    var storePickerView: UIPickerView! {
        didSet {
            self.storePickerView.delegate = self
            self.storePickerView.dataSource = self
            self.storePickerView.reloadAllComponents()
        }
    }
    
    var mealPickerView: UIPickerView! {
        didSet {
            self.storePickerView.delegate = self
            self.storePickerView.dataSource = self
            self.storePickerView.reloadAllComponents()
        }
    }
    
    // MARK: - Value按鈕
    let selectNoodelValueButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
        button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        return button
    }()
    let selectSouplValueButton: UIButton = {
        let button = UIButton()
        button.tag = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
        button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        return button
    }()
    let selectHappyValueButton: UIButton = {
        let button = UIButton()
        button.tag = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
        button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 評論按鈕
    let writeCommentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
        button.addTarget(self, action: #selector(writeComment), for: .touchUpInside)
        return button
    }()
    let notWriteCommentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
        button.addTarget(self, action: #selector(notWriteComment), for: .touchUpInside)
        return button
    }()
}
// MARK: - Button objc func
extension CommentSelectionView {
    @objc func selectValue(sender: UIButton) {
        let selectionType: SelectionType = {
            switch sender {
            case selectNoodelValueButton:
                return SelectionType.noodle
            case selectSouplValueButton:
                return SelectionType.soup
            case selectHappyValueButton:
                return SelectionType.happy
            default:
                return SelectionType.happy
            }
        }()
        self.delegate?.didTapSelectSoupValue(self, type: selectionType)
    }
    @objc func writeComment() {
        self.delegate?.didTapWriteComment(self)
    }
    @objc func notWriteComment() {
        self.delegate?.didTapNotWriteComment(self)
    }
    @objc func downloadImage() {
        self.delegate?.didTapDownloadImage(self)
    }
    @objc func sendComment() {
        self.delegate?.didTapSendComment(self)
    }
    @objc func saveCommentDraft() {
        self.delegate?.didTapSaveComment(self)
    }
    
}

extension CommentSelectionView: UITextFieldDelegate {
    private func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.B2
        }
    }
    private func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            switch textView {
            case selectedStoreTextField:
                textView.text = "輸入店家"
            case selectedMealTextField:
                textView.text = "輸入品項"
            default:
                textView.text = ""
            }
        }
    }
}
extension CommentSelectionView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case storePickerView:
            return stores.count
        case mealPickerView:
            var storeHodler: Store?
            for store in stores where selectedStoreID == store.storeID {
                storeHodler = store
            }
            guard let storeHodler = storeHodler else {
                return 0
            }
            return storeHodler.meals.count
        default :
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case storePickerView:
            return stores[row].name
        case mealPickerView:
            var storeHodler: Store?
            for store in stores where selectedStoreID == store.storeID {
                storeHodler = store
            }
            guard let storeHodler = storeHodler else {
                return ""
            }
            return storeHodler.meals[row]
        default :
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case storePickerView:
            selectedStoreTextField.text = stores[row].storeID
            self.delegate?.didGetSelectStore(self, storeID: selectedStoreID)
        case mealPickerView:
            for store in stores where selectedStoreID == store.storeID {
                for store in stores where selectedStoreID == store.storeID {
                    let meal = store.meals[row]
                    selectedMealTextField.text = meal
                    self.delegate?.didGetSelectMeal(self, meal: meal)
                }
            }
        default :
            return
        }
        
    }
}
