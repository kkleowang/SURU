//
//  LottieLiquidView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/21.
//

import Foundation
import UIKit
import Lottie

class LottieLiquidView: UIView {
    weak var delegate: SelectionValueManager?
    
    var selectionType: SelectionType?
    
    var lottieView = AnimationView()
    func settingLottieView(_ selectionType: SelectionType) {
        self.addSubview(lottieView)
        self.clipsToBounds = true
        switch selectionType {
        case .noodle :
            lottieView = AnimationView(name: "blue")
        case .soup :
            lottieView = AnimationView(name: "yellow")
        case .happy :
            lottieView = AnimationView(name: "orange")
        }
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lottieView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 192).isActive = true
        lottieView.heightAnchor.constraint(equalToConstant: 480).isActive = true
        lottieView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        lottieView.contentMode = .scaleAspectFill
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        lottieView.addGestureRecognizer(pan)
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 1
        lottieView.play()
        
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let controlledView = sender.view
        let translation = sender.translation(in: self)
        guard let centerY = controlledView?.center.y, let centerX = controlledView?.center.x else { return }
        switch sender.state {
        case .began, .changed:
            let result = centerY + translation.y
            if result < 240 {
                controlledView?.center = CGPoint(x: centerX, y: 240)
            } else if result > 680 {
                controlledView?.center = CGPoint(x: centerX, y: 600)
            } else {
                controlledView?.center = CGPoint(x: centerX, y: result)
            }
            sender.setTranslation(CGPoint.zero, in: self)
        case .ended:
            let selectionValue = Double((centerY - 720) / -48).ceiling(toDecimal: 1)
            print("Get gesture value", selectionValue)
        default:
            return
        }
    }
}

