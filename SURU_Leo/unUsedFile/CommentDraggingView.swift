////
////  CommentDraggingView.swift
////  SURU_Leo
////
////  Created by LEO W on 2022/4/21.
////
//
//import Foundation
//import UIKit
//import Lottie
//
//enum SelectionType: String {
//    case noodle = "麵條喜好度"
//    case soup = "湯頭喜好度"
//    case happy = "幸福感"
//}
//enum SelectionSubTitle: String {
//    case text = "拖曳後記得按下儲存"
//}
//protocol CommentDraggingViewDelegate: AnyObject {
//    func didGetSelectionValue(view: CommentDraggingView, type: SelectionType, value: Double)
//    
//    func didTapBackButton(view: CommentDraggingView)
//}
//
//class CommentDraggingView: UIView {
//    weak var delegate: CommentDraggingViewDelegate?
//    
//    var selectionType: SelectionType = .noodle
//    
//    let titleLabel = UILabel()
//    
//    let subTitleLabel = UILabel()
//    
//    var lottieView = AnimationView()
//    
//    let saveButton = UIButton()
//    
//    func layoutDraggingView(type: SelectionType) {
//        self.clipsToBounds = false
//        
//        self.corner(byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: 30)
//        self.backgroundColor = .white
//        selectionType = type
//        setTitleLabel()
//        setupLottieView(selectionType)
//        initDashBar(position: [96, 144, 192, 240, 288, 336, 384], value: [8, 7, 6, 5, 4, 3, 2])
//    }
//    
//    func setupLottieView(_ type: SelectionType) {
//        switch type {
//        case .noodle :
//            lottieView = AnimationView(name: "blue")
//        case .soup :
//            lottieView = AnimationView(name: "yellow")
//        case .happy :
//            lottieView = AnimationView(name: "orange")
//        }
//        self.addSubview(lottieView)
//        lottieView.clipsToBounds = true
//        lottieView.isUserInteractionEnabled = true
//        lottieView.translatesAutoresizingMaskIntoConstraints = false
//        lottieView.layer.cornerRadius = 40
//        lottieView.topAnchor.constraint(equalTo: self.topAnchor, constant: 192).isActive = true
//        lottieView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
//        lottieView.heightAnchor.constraint(equalToConstant: 480).isActive = true
//        lottieView.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        lottieView.contentMode = .scaleAspectFill
//        let pan = UIPanGestureRecognizer(target: lottieView, action: #selector(handlePan(sender:)))
//        lottieView.addGestureRecognizer(pan)
//        
//        lottieView.loopMode = .loop
//        lottieView.animationSpeed = 1
//        lottieView.play()
//    }
//    
//    func setTitleLabel() {
//        self.addSubview(titleLabel)
//        self.addSubview(subTitleLabel)
//        
//        let spacing = (UIScreen.height * 0.9 - 480) / 2
//        titleLabel.font = UIFont.regular(size: 30)
//        titleLabel.characterSpacing = 2.5
//        titleLabel.textColor = UIColor.B1
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.leadingAnchor.constraint(equalTo: lottieView.leadingAnchor, constant: 0).isActive = true
//        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing).isActive = true
//        
//        subTitleLabel.font = UIFont.regular(size: 18)
//        subTitleLabel.characterSpacing = 2.5
//        subTitleLabel.textColor = UIColor.B2
//        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
//        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
//    }
//    
//    func initDashBar(position: [CGFloat], value: [Int]) {
//        for line in 0..<position.count {
//            let positionOfDashBar = position[line]
//            let valueOfDashBar = value[line]
//            let dashBar = UIView()
//            self.addSubview(dashBar)
//            dashBar.translatesAutoresizingMaskIntoConstraints = false
//            dashBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 135).isActive = true
//            dashBar.centerYAnchor.constraint(equalTo: lottieView.topAnchor, constant: positionOfDashBar).isActive = true
//            dashBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
//            dashBar.backgroundColor = UIColor.B5
//            if valueOfDashBar % 20 == 0 {
//                dashBar.widthAnchor.constraint(equalToConstant: 70).isActive = true
//                let valueLabel = UILabel()
//                self.addSubview(valueLabel)
//                valueLabel.textColor = UIColor.B6
//                valueLabel.translatesAutoresizingMaskIntoConstraints = false
//                valueLabel.leadingAnchor.constraint(equalTo: dashBar.trailingAnchor, constant: 5).isActive = true
//                valueLabel.centerYAnchor.constraint(equalTo: dashBar.centerYAnchor, constant: 0).isActive = true
//                valueLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
//                valueLabel.text = String(valueOfDashBar)
//            } else {
//                dashBar.widthAnchor.constraint(equalToConstant: 25).isActive = true
//            }
//        }
//    }
//    func setSaveButton() {
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        saveButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
//        saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
//        saveButton.layer.cornerRadius = 20
//        saveButton.setImage( UIImage(named: "plue"), for: .normal)
//        saveButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
//        saveButton.backgroundColor = .black.withAlphaComponent(0.4)
//        saveButton.tintColor = .white
//        saveButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//    }
//    @objc func handlePan(sender: UIPanGestureRecognizer) {
//        let controlledView = sender.view
//        let translation = sender.translation(in: self)
//        guard let centerY = controlledView?.center.y, let centerX = controlledView?.center.x else { return }
//        switch sender.state {
//        case .began, .changed:
//            let result = centerY + translation.y
//            if result < 240 {
//                controlledView?.center = CGPoint(x: centerX, y: 240)
//            } else if result > 680 {
//                controlledView?.center = CGPoint(x: centerX, y: 600)
//            } else {
//                controlledView?.center = CGPoint(x: centerX, y: result)
//            }
//            sender.setTranslation(CGPoint.zero, in: self)
//        case .ended:
//            let selectionValue = Double((centerY - 720) / -48).ceiling(toDecimal: 1)
//            self.delegate?.didGetSelectionValue(view: self, type: selectionType, value: selectionValue)
//            print("Get gesture value", selectionValue)
//        default:
//            return
//        }
//    }
//    
//    @objc func tapBackButton() {
//        self.delegate?.didTapBackButton(view: self)
//    }
//}
