//
//  liquidBarViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import Lottie
import UIKit

protocol LiquidViewDelegate: AnyObject {
    func didGetSelectionValue(view: LiquidBarViewController, type: SelectionType, value: Double)
}

protocol LiquidViewDrawValueDelegate: AnyObject {
    func didGetSelectionValue(view: LiquidBarViewController, type: SelectionType, value: Double)
}

protocol LiquidBarViewControllerTOValue: AnyObject {
    func didChangeValue(view: LiquidBarViewController, value: Double)
}

class LiquidBarViewController: UIViewController {
    let mask = CALayer()
    var selectionType: SelectionType?
    weak var valueDelegate: LiquidBarViewControllerTOValue?
    weak var delegate: LiquidViewDelegate?
    weak var drawDelegate: LiquidViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setLottieView(_ type: SelectionType) {
        selectionType = type
        view.clipsToBounds = true
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
        case .began, .changed:
            guard let positionY = controledView?.center.y, let positionX = controledView?.center.x else { return }
            let total = positionY + translation.y
            if total <= 240 {
                let selectionValue = 10.0
                valueDelegate?.didChangeValue(view: self, value: selectionValue)
                controledView?.center = CGPoint(x: positionX, y: 240)
            } else if total >= 600 {
                let selectionValue = 2.5
                valueDelegate?.didChangeValue(view: self, value: selectionValue)
                controledView?.center = CGPoint(x: positionX, y: 600)
                print("fix")
            } else {
                let selectionValue = Double((total - 720) / -48).ceiling(toDecimal: 1)
                valueDelegate?.didChangeValue(view: self, value: selectionValue)
                controledView?.center = CGPoint(x: positionX, y: total)
            }

            sender.setTranslation(CGPoint.zero, in: view)
        case .ended:
            guard let positionY = controledView?.center.y, let selectionType = selectionType else { return }
            var selectionValue = Double((positionY - 720) / -48).ceiling(toDecimal: 1)
            print("Get Value", selectionValue)
            if selectionValue > 10.0 {
                selectionValue = 10.0
            } else if selectionValue <= 2.5 {
                selectionValue = 2.5
            }
            delegate?.didGetSelectionValue(view: self, type: selectionType, value: selectionValue)
            drawDelegate?.didGetSelectionValue(view: self, type: selectionType, value: selectionValue)
            print("end")
        default:
            print("end")
        }
    }
}

// setGradientView
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
