//
// import UIKit
//
// class anc: UIView {
////    //
//    lazy var selectedStoreTextField = UITextField() {
//
//        self.addSubview(selectedStoreTextField)
//            selectedStoreTextField.translatesAutoresizingMaskIntoConstraints = false
//            selectedStoreTextField.backgroundColor = .clear
//            selectedStoreTextField.text = "輸入店家"
//            selectedStoreTextField.textColor = .B1
//            selectedStoreTextField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//            selectedStoreTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
//            selectedStoreTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//            selectedStoreTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//            selectedStoreTextField.inputView = storePickerView
//        self()
//
//    }
//
//    var selectedMealTextField: UITextField? {
//
//        let textField = UITextField()
//        self.addSubview(textField)
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.backgroundColor = .clear
//        textField.text = "輸入品項"
//        textField.textColor = .B1
//        textField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
//        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//        textField.inputView = mealPickerView
//        return textField
//    }
//    selectedMealTextField?.isHidden = false
//
//    var storePickerView: UIPickerView? {
//        let pickView = UIPickerView()
//        pickView.tag = 1
//        pickView.delegate = self
//        pickView.dataSource = self
//        pickView.reloadAllComponents()
//        return pickView
//    }
//    
//    var mealPickerView: UIPickerView? {
//        let pickView = UIPickerView()
//        pickView.tag = 2
//        pickView.delegate = self
//        pickView.dataSource = self
//        pickView.reloadAllComponents()
//        return pickView
//    }
//    
//    var selectNoodelValueButton: UIButton? {
//        let button = UIButton()
//        self.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        button.layer.cornerRadius = 15
//        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
//        button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
//        return button
//    }
//    var selectSouplValueButton: UIButton? {
//        let button = UIButton()
//        self.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        button.layer.cornerRadius = 15
//        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
//        button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
//        return button
//    }
//    var selectHappyValueButton: UIButton? {
//        let button = UIButton()
//        self.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        button.layer.cornerRadius = 15
//        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
//        button.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
//        return button
//    }
//    
//    var writeCommentButton: UIButton? {
//        let button = UIButton()
//        self.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        button.layer.cornerRadius = 15
//        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
//        button.addTarget(self, action: #selector(writeComment), for: .touchUpInside)
//        return button
//    }
//    var notWriteCommentButton: UIButton? {
//        let button = UIButton()
//        self.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        button.layer.cornerRadius = 15
//        button.setImage( UIImage(named: SelectionButton.selectMeal.rawValue), for: .normal)
//        button.addTarget(self, action: #selector(notWriteComment), for: .touchUpInside)
//        return button
//    }
//    func layoutSelectView(dataSource: [Store]) {
//        stores = dataSource
//        self.layer.cornerRadius = 40
//        self.clipsToBounds = true
//        let storeTextField = selectedStoreTextField()
//        let mealTextField = selectedMealTextField()
//    }
// }
//
