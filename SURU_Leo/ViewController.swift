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
    let mask = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        let animationView = AnimationView(name: "wave")
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        mask.backgroundColor = UIColor.black.cgColor
        mask.frame = CGRect(x: 50, y: 50, width: 150, height: 800)
        //        mask.cornerRadius =  mask.frame.width/2
        animationView.layer.mask = mask
        view.addSubview(animationView)
        
        animationView.play(completion: nil)
        setGesture(importView: animationView)
        //        let doc: DocumentReference
        
        
        //        self.view.addSubview(processedImage)
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
            print("end")
            break
        default:
            print("end")
            break
        }
    }
    
}

