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
    let liquilBarview = LiquidBarViewController()
    
    func setupLayout(type: SelectionTitle) {
        switch type {
        case .noodle :
            titleLabel.text = type.rawValue
        case .soup :
            titleLabel.text = type.rawValue
        case .happy :
            titleLabel.text = type.rawValue
        }
        titleLabel.font = UIFont.regular(size: 18)
        titleLabel.characterSpacing = 2.5
        subTitleLabel.font = UIFont.regular(size: 14)
        subTitleLabel.characterSpacing = 2.5
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        subTitleLabel.text = SelectionSubTitle.text.rawValue
        initDashBar(position: [96, 144, 192, 240, 288, 336, 384], value: [80, 70, 60, 50, 40 , 30, 20])
//        initDashBar(position: 336, value: 80)
//        initDashBar(position: 384)
//        initDashBar(position: 432, value: 60)
//        initDashBar(position: 480)
//        initDashBar(position: 528, value: 40)
//        initDashBar(position: 576)
//        initDashBar(position: 624, value: 20)
    }
    func initDashBar(position: [CGFloat], value: [Int]) {
        for line in 0..<position.count {
            let positionOfDashBar = position[line]
            let valueOfDashBar = value[line]
            let dashBar = UIView()
            self.view.addSubview(dashBar)
            dashBar.translatesAutoresizingMaskIntoConstraints = false
            dashBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 135).isActive = true
            dashBar.centerYAnchor.constraint(equalTo: liquilBarview.view.topAnchor, constant: positionOfDashBar).isActive = true
            dashBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
            dashBar.backgroundColor = UIColor.gray
            if valueOfDashBar % 20 == 0 {
                dashBar.widthAnchor.constraint(equalToConstant: 30).isActive = true
                let valueLabel = UILabel()
                self.view.addSubview(valueLabel)
                valueLabel.translatesAutoresizingMaskIntoConstraints = false
                valueLabel.leadingAnchor.constraint(equalTo: dashBar.trailingAnchor, constant: 5).isActive = true
                valueLabel.topAnchor.constraint(equalTo: dashBar.topAnchor, constant: 0).isActive = true
                valueLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                valueLabel.text = String(valueOfDashBar)
            } else {
                dashBar.widthAnchor.constraint(equalToConstant: 10).isActive = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackButton()
        setLiquidView()
    }
    
    func setLiquidView() {
        
        self.addChild(liquilBarview)
        self.view.addSubview(liquilBarview.view)
        liquilBarview.view.translatesAutoresizingMaskIntoConstraints = false
        liquilBarview.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIScreen.height/10).isActive = true
        liquilBarview.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        liquilBarview.view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        liquilBarview.view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        liquilBarview.view.backgroundColor = UIColor.white
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
