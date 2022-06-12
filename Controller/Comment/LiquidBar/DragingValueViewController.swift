//
//  DragingValueViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/12.
//

import UIKit

protocol CommentDraggingViewDelegate: AnyObject {
    func didTapSendValue(_ viewController: DragingValueViewController, value: Double, type: SelectionType)
}

enum SelectionType: String {
    case noodle = "麵條喜好度："
    case soup = "湯頭喜好度："
    case happy = "綜合評價："
}

class DragingValueViewController: UIViewController {
    weak var delegate: CommentDraggingViewDelegate?
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let valueLabel = UILabel()
    let liquilBarview = LiquidBarViewController()
    var selectionType: SelectionType = .noodle
    var selectValue: Double = 5.0 {
        didSet {
            valueLabel.text = String(selectValue)
        }
    }

    func setupLayout(_ type: SelectionType) {
        selectionType = type
        switch selectionType {
        case .noodle:
            titleLabel.text = selectionType.rawValue
        case .soup:
            titleLabel.text = selectionType.rawValue
        case .happy:
            titleLabel.text = selectionType.rawValue
        }
        setBackButton()
        setLiquidView()
        let spacing = (UIScreen.height * 0.9 - 480) / 2
        titleLabel.font = UIFont.regular(size: 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.characterSpacing = 2.5
        titleLabel.textColor = UIColor.B1

        subTitleLabel.font = UIFont.regular(size: 18)

        subTitleLabel.characterSpacing = 2.5
        subTitleLabel.textColor = UIColor.B2
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: liquilBarview.view.leadingAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: spacing).isActive = true
        view.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        valueLabel.font = .medium(size: 20)
        valueLabel.text = String(5.0)
        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        //        subTitleLabel.text = SelectionSubTitle.text.rawValue
        initDashBar(position: [96, 144, 192, 240, 288, 336, 384], value: [8, 7, 6, 5, 4, 3, 2])
    }

    func initDashBar(position: [CGFloat], value: [Int]) {
        for line in 0 ..< position.count {
            let positionOfDashBar = position[line]
            let valueOfDashBar = value[line]
            let dashBar = UIView()
            view.addSubview(dashBar)
            dashBar.translatesAutoresizingMaskIntoConstraints = false
            dashBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 135).isActive = true
            dashBar.centerYAnchor.constraint(equalTo: liquilBarview.view.topAnchor, constant: positionOfDashBar).isActive = true
            dashBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
            dashBar.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

            if valueOfDashBar % 20 == 0 {
                dashBar.widthAnchor.constraint(equalToConstant: 70).isActive = true
                let valueLabel = UILabel()
                view.addSubview(valueLabel)
                valueLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                valueLabel.translatesAutoresizingMaskIntoConstraints = false
                valueLabel.leadingAnchor.constraint(equalTo: dashBar.trailingAnchor, constant: 5).isActive = true
                valueLabel.centerYAnchor.constraint(equalTo: dashBar.centerYAnchor, constant: 0).isActive = true
                valueLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                valueLabel.text = String(valueOfDashBar)
            } else {
                dashBar.widthAnchor.constraint(equalToConstant: 25).isActive = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setSwipeGesture() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipe.direction = .left
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(swipe)
    }
    @objc func swipeLeft() {
        self.delegate?.didTapSendValue(self, value: selectValue, type: selectionType)
    }
    func setLiquidView() {
        addChild(liquilBarview)
        view.addSubview(liquilBarview.view)
        liquilBarview.setLottieView(selectionType)
        liquilBarview.view.translatesAutoresizingMaskIntoConstraints = false
        liquilBarview.view.layer.cornerRadius = 40
        liquilBarview.delegate = self
        liquilBarview.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.height / 10).isActive = true
        liquilBarview.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        liquilBarview.view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        liquilBarview.view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        liquilBarview.view.backgroundColor = UIColor.white
    }
   
    func setBackButton() {
        let sendButton = UIButton()
        view.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.cornerRadii(radii: 10)

//        sendButton.setImage(UIImage(named: "plus"), for: .normal)
        sendButton.setTitle("送出評分", for: .normal)
        sendButton.backgroundColor = .B1
        sendButton.tintColor = .white
        sendButton.titleLabel?.adjustsFontSizeToFitWidth = true
        sendButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        sendButton.addTarget(self, action: #selector(tapSend), for: .touchUpInside)
    }

    @objc func tapSend() {
        self.delegate?.didTapSendValue(self, value: selectValue, type: selectionType)
    }
}

extension DragingValueViewController: LiquidBarViewControllerDelegate {
    func didGetSelectionValue(_ viewController: LiquidBarViewController, value: Double) {
        selectValue = value
    }
}
