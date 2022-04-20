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
    
    var selectedStoreTextField: UITextField! {
        didSet {
            self.selectedMealTextField.delegate = self
        }
    }
    var selectedMealTextField: UITextField! {
        didSet {
            self.selectedMealTextField.delegate = self
        }
    }
    let selectValueButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        
        button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        return button
    }()
    var storePickerView: UIPickerView! {
        didSet {
            self.storePickerView.delegate = self
            self.storePickerView.dataSource = self
            self.storePickerView.reloadAllComponents()
        }
    }
    let mealPickerView: UIPickerView! {
        didSet {
            self.storePickerView.delegate = self
            self.storePickerView.dataSource = self
            self.storePickerView.reloadAllComponents()
        }
    }
    var selectedStoreID: String = ""
    var stores: [Store] = []
    
    // MARK: -
   
    // MARK: -
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
    // MARK: -
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
    
    func layoutCommentSelectionView(dataSource: [Store]) {
        self.backgroundColor = .C1
        self.layer.cornerRadius = 30
        storeData = dataSource
        //        setupViews(view: storePickerTextField)
        //        setupViews(view: mealPickerTextField)
        //        setupViews(view: likeButton)
        //        setupViews(view: commentButton)
        //        setupViews(view: sendButton)
        //        storePickerTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        //        mealPickerTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70).isActive = true
        //        likeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 130).isActive = true
        //        commentButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 190).isActive = true
        //        sendButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 250).isActive = true
        //        sendButton.backgroundColor = .C7
        ////        storePicker.dataSource = self
        ////        storePicker.delegate = self
        ////        storePicker.tag = 100
        ////        storePickerTextField.inputView = storePicker
        ////        storePickerTextField.backgroundColor = .red
        ////
        ////        mealPicker.dataSource = self
        ////        mealPicker.delegate = self
        ////        mealPicker.tag = 200
        ////        mealPickerTextField.inputView = mealPicker
        ////        mealPickerTextField.backgroundColor = .red
        //        likeButton.backgroundColor = .red
        //        commentButton.backgroundColor = .red
        //        sendButton.addTarget(self, action: #selector(sendData), for: .touchUpInside)
        //        likeButton.addTarget(self, action: #selector(showLikeView), for: .touchUpInside)
        //        commentButton.addTarget(self, action: #selector(showCommentView), for: .touchUpInside)
        
    }
    
    func setupViews(view: UIView){
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    }
}
func setupViewWithIcon(icon: String, size: Double)-> UIView {
    
    let imageView = UIImageView()
    let view = UIView()
    self.addSubview(imageView)
    self.addSubview(view)
    view.frame = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 100, height: 100)
    view.layer.cornerRadius = 100 / 2
    view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    
    imageView.image =  UIImage(named: "store")
    imageView.frame = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 100 * 0.8, height: 100 * 0.8)
    imageView.tintColor = .B1
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
