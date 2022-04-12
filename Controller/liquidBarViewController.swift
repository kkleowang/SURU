//
//  liquidBarViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit
import Lottie
class LiquidBarViewController: UIViewController {
    let mask = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLottieView()
    }
    //AnimationViewHolder
    func setLottieView() {
        let animationView = AnimationView(name: "wave")
        animationView.center = self.view.center
        view.addSubview(animationView)
//        animationView.frame = CGRect(x: 0, y: 0, width: 600, height: 200)
        animationView.contentMode = .scaleAspectFill
        mask.backgroundColor = UIColor.black.cgColor
        mask.frame = CGRect(x: 0, y: 0, width: 150, height: 300)
        animationView.layer.mask = mask
        
        
        animationView.play(completion: nil)
        setGesture(importView: animationView)
    }
    
    func setGesture(importView: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        importView.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let controledView = sender.view
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began, .changed:
            controledView?.center = CGPoint(x: (controledView?.center.x)! , y: (controledView?.center.y)! + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        case .ended:
            print(translation.y)
            print(controledView?.center.y)
            print((controledView?.center.y)! + translation.y)
            print("end")
        default:
            print("end")
        }
    }
}
