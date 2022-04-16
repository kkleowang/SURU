//
//  liquidBarViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit
import Lottie

protocol SelectionValueManager: AnyObject {
    func getSelectionValue(type: SelectionType, value: Int)
}

class LiquidBarViewController: UIViewController {
    let mask = CALayer()
    var selectionType: SelectionType = .noodle
    weak var delegate: SelectionValueManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        setLottieView()
        view.clipsToBounds = true
    }
    // AnimationViewHolder
    func setLottieView() {
        let animationView = setGradientView()
        self.view.addSubview(animationView)
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
            guard let positionY = controledView?.center.y, let positionX = controledView?.center.x else { return }
            let total = positionY + translation.y
            if total < 240 {
                controledView?.center = CGPoint(x: positionX, y: 240)
            } else if total > 680 {
                controledView?.center = CGPoint(x: positionX, y: 600)
            } else {
                controledView?.center = CGPoint(x: positionX, y: total)
            }
            sender.setTranslation(CGPoint.zero, in: view)
        case .ended:
            guard let positionY = controledView?.center.y else { return }
            let selectionValue = Int((positionY - 720) / -4.8)
            print("Get Value", selectionValue)
            delegate?.getSelectionValue(type: selectionType, value: selectionValue)
            print("end")
        default:
            print("end")
        }
    }
}
// setGradientView
extension LiquidBarViewController {
    func setGradientView() -> UIView {
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 480))
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.C2?.cgColor, UIColor.C3?.cgColor, UIColor.C4?.cgColor, UIColor.C7?.cgColor]
        
        gradientView.layer.addSublayer(gradientLayer)
        
        return gradientView
    }
}
