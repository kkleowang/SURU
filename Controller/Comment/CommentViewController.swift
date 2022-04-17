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

class CommentViewController: UIViewController {
    @IBAction func noodleButton(_ sender: UIButton) {
        presentsideView(.noodle)
    }
    @IBAction func soupButton(_ sender: UIButton) {
        presentsideView(.soup)
    }
    @IBAction func happyButton(_ sender: UIButton) {
        presentsideView(.happy)
    }
    let mask = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.C1
    }
    
    
    func presentsideView(_ type: SelectionType) {
        let controller = DragingValueViewController()
        controller.liquilBarview.delegate = self
        self.addChild(controller)
        view.addSubview(controller.view)
        controller.view.backgroundColor = UIColor.C5
        controller.view.frame = CGRect(x: -300, y: 0, width: 300, height: UIScreen.main.bounds.height)
        controller.view.corner(byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: 30)
        controller.selectionType = type
        UIView.animate(withDuration: 0.5) {
            controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: UIScreen.main.bounds.height)
        }
    }
}

extension CommentViewController: SelectionValueManager {
    func getSelectionValue(type: SelectionType, value: Int) {
        switch type {
        case .noodle :
            print("got noodle", value)
        case .soup :
            print("got soup", value)
        case .happy :
            print("got happy", value)
        }
    }
    
    func getSelectionValue(didGet: Int) {
        print("got", didGet)
    }
    
}
