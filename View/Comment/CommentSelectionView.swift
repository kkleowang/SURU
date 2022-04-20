//
//  CommentSelectionView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit
import Alamofire


protocol CommentSelectionViewDelegate: AnyObject {
    func didTapSelectStore(_ view: CommentSelectionView, storeID: String)
    
    func didTapSelectMeal(_ view: CommentSelectionView, meal: String)
    
    func didTapSelectNoodleValue(_ view: CommentSelectionView)
    
    func didTapSelectSoupValue(_ view: CommentSelectionView)
    
    func didTapSelectHappyValue(_ view: CommentSelectionView)
    
    func didTapWriteComment(_ view: CommentSelectionView)
    
    func didTapNotWriteComment(_ view: CommentSelectionView)
    
    func didTapSendComment(_ view: CommentSelectionView)
    
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
    
    
    
    var selectedStoreID: String = ""
    var storeData: [Store] = []
    let storePicker = UIPickerView()
    let mealPicker = UIPickerView()
    // MARK: -
    let selectStoreButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        button.setImage( UIImage(named: SelectionButton.selectStore.rawValue), for: .normal)
        button.addTarget(self, action: #selector(selectStore), for: .touchUpInside)
        return button
    }()
    
    let selectMealButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
        button.addTarget(self, action: #selector(selectMeal), for: .touchUpInside)
        return button
    }()

    // MARK: -
    let selectNoodelValueButton: UIButton = {
       let button = UIButton()
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
    @objc func sendData() {
        self.delegate?.didTapSendData(self)
    }
    @objc func showLikeView() {
        self.delegate?.didTapLikeView(self)
    }
    @objc func showCommentView() {
        self.delegate?.didgetSelectedComment(self, comment: "我是評論測試\(Date())")
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
extension  CommentSelectionView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count: Int?
        if pickerView.tag == 100 {
            count = storeData.count
        } else {
            for storedata in storeData where selectedStoreID == storedata.storeID {
                count = storedata.meals.count
            }
        }
        guard let count = count else {
            return 1
        }
        
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var count: String?
        if pickerView.tag == 100 {
            count = storeData[row].name
        } else {
            for storedata in storeData where selectedStoreID == storedata.storeID {
                count = storedata.meals[row]
            }
        }
        return count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 100 {
            selectedStoreID = storeData[row].storeID
            mealPicker.reloadAllComponents()
            self.delegate?.didgetSelectedStore(self, storeID: selectedStoreID)
        } else {
            for storedata in storeData where selectedStoreID == storedata.storeID {
                let meal = storedata.meals[row]
                self.delegate?.didgetSelectedMeal(self, meal: meal)
            }
        }
    }
}
// MARK: - Button objc func
extension CommentSelectionView {
    @objc func selectStore() {
        self.delegate.
    }
    @objc func selectMeal() {
        
    }
    @objc func selectValue(sender: UIButton) {
        
    }
    @objc func writeComment() {
        
    }
    @objc func notWriteComment() {
        
    }
    @objc func downloadImage() {
        
    }
    @objc func sendComment() {
        
    }
    @objc func saveCommentDraft() {
        
    }
    
}
