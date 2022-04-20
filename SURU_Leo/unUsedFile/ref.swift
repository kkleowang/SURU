//
//  ref.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/21.
//
/*
 // MARK: - 選取店家物件
 var selectedStoreTextField: UITextField? {
     let textField = UITextField()
     self.addSubview(textField)
     textField.translatesAutoresizingMaskIntoConstraints = false
     textField.backgroundColor = .clear
     textField.text = "輸入店家"
     textField.textColor = .B1
     textField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
     textField.heightAnchor.constraint(equalToConstant: 70).isActive = true
     textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
     textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
     textField.inputView = storePickerView
     return textField
 }
 
 var selectedMealTextField: UITextField? {
     let textField = UITextField()
     self.addSubview(textField)
     textField.translatesAutoresizingMaskIntoConstraints = false
     textField.backgroundColor = .clear
     textField.text = "輸入品項"
     textField.textColor = .B1
     textField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
     textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
     textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
     textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
     textField.inputView = mealPickerView
     return textField
 }
 
 var storePickerView: UIPickerView? {
     let pickView = UIPickerView()
     pickView.tag = 1
     pickView.delegate = self
     pickView.dataSource = self
     pickView.reloadAllComponents()
     return pickView
 }
 
 var mealPickerView: UIPickerView? {
     let pickView = UIPickerView()
     pickView.tag = 2
     pickView.delegate = self
     pickView.dataSource = self
     pickView.reloadAllComponents()
     return pickView
 }
 
 // MARK: - Value按鈕
 var selectNoodelValueButton: UIButton? {
     let button = UIButton()
     self.addSubview(button)
     button.translatesAutoresizingMaskIntoConstraints = false
     button.widthAnchor.constraint(equalToConstant: 30).isActive = true
     button.heightAnchor.constraint(equalToConstant: 30).isActive = true
     button.layer.cornerRadius = 15
     button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
     button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
     return button
 }
 var selectSouplValueButton: UIButton? {
     let button = UIButton()
     self.addSubview(button)
     button.translatesAutoresizingMaskIntoConstraints = false
     button.widthAnchor.constraint(equalToConstant: 30).isActive = true
     button.heightAnchor.constraint(equalToConstant: 30).isActive = true
     button.layer.cornerRadius = 15
     button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
     button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
     return button
 }
 var selectHappyValueButton: UIButton? {
     let button = UIButton()
     self.addSubview(button)
     button.translatesAutoresizingMaskIntoConstraints = false
     button.widthAnchor.constraint(equalToConstant: 30).isActive = true
     button.heightAnchor.constraint(equalToConstant: 30).isActive = true
     button.layer.cornerRadius = 15
     button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
     button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
     return button
 }
 
 // MARK: - 評論按鈕
 var writeCommentButton: UIButton? {
     let button = UIButton()
     self.addSubview(button)
     button.translatesAutoresizingMaskIntoConstraints = false
     button.widthAnchor.constraint(equalToConstant: 30).isActive = true
     button.heightAnchor.constraint(equalToConstant: 30).isActive = true
     button.layer.cornerRadius = 15
     button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
     button.addTarget(self, action: #selector(writeComment), for: .touchUpInside)
     return button
 }
 var notWriteCommentButton: UIButton? {
     let button = UIButton()
     self.addSubview(button)
     button.translatesAutoresizingMaskIntoConstraints = false
     button.widthAnchor.constraint(equalToConstant: 30).isActive = true
     button.heightAnchor.constraint(equalToConstant: 30).isActive = true
     button.layer.cornerRadius = 15
     button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
     button.addTarget(self, action: #selector(notWriteComment), for: .touchUpInside)
     return button
 }
 func layoutSelectView(dataSource: [Store]) {
     stores = dataSource
     self.layer.cornerRadius = 40
     self.clipsToBounds = true
     let storeTextField = selectedStoreTextField()
     let mealTextField = selectedMealTextField()
 }
 */

