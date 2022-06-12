//
//  liquidBarViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import Lottie
import UIKit

protocol LiquidBarViewControllerDelegate: AnyObject {
    func didGetSelectionValue(_ viewController: LiquidBarViewController, value: Double)
}
class LiquidBarViewController: UIViewController {
    let mask = CALayer()
    var selectionType: SelectionType?
    weak var delegate: LiquidBarViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setLottieView(_ type: SelectionType) {
        view.clipsToBounds = true
        selectionType = type
        let animationView = settingLottieView()
        view.addSubview(animationView)
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
        case .began, .changed, .ended:
            guard let positionY = controledView?.center.y, let positionX = controledView?.center.x else { return }
            let total = positionY + translation.y
            var selectionValue = Double((positionY - 720) / -48).ceiling(toDecimal: 1)
            if selectionValue > 10.0 {
                selectionValue = 10.0
            } else if selectionValue <= 2.5 {
                selectionValue = 2.5
            }
            self.delegate?.didGetSelectionValue(self, value: selectionValue)
            if total <= 240 {
                controledView?.center = CGPoint(x: positionX, y: 240)
            } else if total >= 600 {
                controledView?.center = CGPoint(x: positionX, y: 600)
            } else {
                controledView?.center = CGPoint(x: positionX, y: total)
            }
            sender.setTranslation(CGPoint.zero, in: view)
        default:
            print("")
        }
    }
}

extension LiquidBarViewController {
    func settingLottieView() -> UIView {
        guard let selectionType = selectionType else { return UIView() }
        var liqid = "yellow"
        switch selectionType {
        case .noodle:
            liqid = "yellow"
        case .soup:
            liqid = "blue"
        case .happy:
            liqid = "orange"
        }
        let animationView = AnimationView(name: liqid)
        animationView.frame = CGRect(x: 0, y: 192, width: 80, height: 480)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
        return animationView
    }
}
