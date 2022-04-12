//
//  DragingValueViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit

enum SelectionTitle: String {
    case noodle = "麵條喜好度"
    case soup = "湯頭喜好度"
    case happy = "幸福感"
}
enum SelectionSubTitle: String {
    case text = "拖曳後記得按下儲存"
}

class DragingValueViewController: UIViewController {
//    let backButton = UIButton()
//    let uiview = UIView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    func setupLayout(type: SelectionTitle) {
        switch type {
        case .noodle :
            titleLabel.text = type.rawValue
        case .soup :
            titleLabel.text = type.rawValue
        case .happy :
            titleLabel.text = type.rawValue
        }
        subTitleLabel.text = SelectionSubTitle.text.rawValue
        setupBarValueBar()
        
    }
    func setupBarValueBar() {
        let view = UIView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackButton()
        setLiquidView()
    }
    
    func setLiquidView() {
        let view = LiquidBarViewController()
        self.addChild(view)
        self.view.addSubview(view.view)
        view.view.translatesAutoresizingMaskIntoConstraints = false
        view.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIScreen.height/10).isActive = true
        view.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        view.view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        view.view.backgroundColor = UIColor.white
    }
    func setBackButton() {
        let backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.backgroundColor = UIColor.red
        backButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
    }
    
    @objc func dismissSelf() {
        self.view.removeFromSuperview()
    }
    
}
