//
//  ViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/9.
//

import UIKit
import Lottie
import Kingfisher
import Firebase
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    @IBAction func noodle(_ sender: UIButton) {
        presentsideView()
    }
    let mask = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.C1
    }
    
    
    func presentsideView() {
        let controller = DragingValueViewController()
        self.addChild(controller)
        view.addSubview(controller.view)
        controller.view.backgroundColor = UIColor.C5
        controller.view.frame = CGRect(x: -335, y: 0, width: 335, height: UIScreen.main.bounds.height)
        controller.view.corner(byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: 30)
        UIView.animate(withDuration: 0.5) {
            controller.view.frame = CGRect(x: 0, y: 0, width: 335, height: UIScreen.main.bounds.height)
        }
    }
    
}
