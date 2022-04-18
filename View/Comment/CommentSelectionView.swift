//
//  CommentSelectionView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import UIKit
import Alamofire


protocol SURUCommentSelectionViewDelegate: AnyObject {
    func didgetSelectedStore(_ view: CommentSelectionView, storeID: String)
    
    func didgetSelectedMeal(_ view: CommentSelectionView, meal: String)
    
    //    func didgetSelectedLike(_ view: CommentSelectionView, like: CommentContent)
    
    func didgetSelectedComment(_ view: CommentSelectionView, comment: String)
    
    func didTapLikeView(_ view: CommentSelectionView)
    
    func didTapSendData(_ view: CommentSelectionView)
}

class CommentSelectionView: UIView {
    
    weak var delegate: SURUCommentSelectionViewDelegate?
    let storePickerTextField = UITextField()
    let mealPickerTextField  = UITextField()
    let likeButton = UIButton()
    let commentButton = UIButton()
    var selectedStoreID: String = ""
    var storeData: [Store] = []
    let storePicker = UIPickerView()
    let mealPicker = UIPickerView()
    let sendButton = UIButton()
    
    func layoutCommentSelectionView(dataSource: [Store]) {
        self.backgroundColor = .C1
        self.layer.cornerRadius = 30
        storeData = dataSource
        setupViews(view: storePickerTextField)
        setupViews(view: mealPickerTextField)
        setupViews(view: likeButton)
        setupViews(view: commentButton)
        setupViews(view: sendButton)
        storePickerTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        mealPickerTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 130).isActive = true
        commentButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 190).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 250).isActive = true
        sendButton.backgroundColor = .C7
        storePicker.dataSource = self
        storePicker.delegate = self
        storePicker.tag = 100
        storePickerTextField.inputView = storePicker
        storePickerTextField.backgroundColor = .red
       
        mealPicker.dataSource = self
        mealPicker.delegate = self
        mealPicker.tag = 200
        mealPickerTextField.inputView = mealPicker
        mealPickerTextField.backgroundColor = .red
        likeButton.backgroundColor = .red
        commentButton.backgroundColor = .red
        sendButton.addTarget(self, action: #selector(sendData), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(showLikeView), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(showCommentView), for: .touchUpInside)
        
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
