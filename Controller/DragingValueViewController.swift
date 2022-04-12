//
//  DragingValueViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit

class DragingValueViewController: UIViewController {
//    let backButton = UIButton()
//    let uiview = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackButton()
        setliqleView()
    }
    func setliqleView() {
        let view = LiquidBarViewController()
        self.addChild(view)
        self.view.addSubview(view.view)
        view.view.translatesAutoresizingMaskIntoConstraints = false
        view.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150).isActive = true
        view.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        view.view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        view.view.backgroundColor = UIColor.C7
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
