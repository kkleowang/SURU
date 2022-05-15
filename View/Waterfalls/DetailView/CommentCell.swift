//
//  CommentCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import UIKit
import Kingfisher

class CommentCell: UITableViewCell {
    @IBOutlet weak var noodleValueView: UIView!
    @IBOutlet weak var soupValueView: UIView!
    @IBOutlet weak var happyValueView: UIView!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var sideDishesLabel: UILabel!
    
    @IBOutlet weak var mealLabel: UILabel!
    
    @IBOutlet weak var noodleLabel: UILabel!
    @IBOutlet weak var soupLabel: UILabel!
    @IBOutlet weak var oveallLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    
    
    func layoutCell(data: Comment, store: Store) {
        for view in [noodleValueView, soupValueView, happyValueView] {
            view?.clipsToBounds = true
            view?.layer.cornerRadius = 60 / 2
        }
        storeNameLabel.adjustsFontSizeToFitWidth = true
        mealLabel.adjustsFontSizeToFitWidth = true
        sideDishesLabel.adjustsFontSizeToFitWidth = true
        storeNameLabel.setDefultFort()
        mealLabel.setDefultFort()
        sideDishesLabel.setDefultFort()
        contentTextView.isEditable = false
        contentTextView.text = data.contenText.replacingOccurrences(of: "\\n", with: "\n")
        mainImageView.loadImage(data.mainImage, placeHolder: UIImage(named: "mainImage"))
        
        storeNameLabel.text = store.name
        mealLabel.text = data.meal
        sideDishesLabel.text = data.sideDishes ?? "無"
        
        
        initValueView(on: noodleValueView, value: data.contentValue.noodle, color: UIColor.C4?.cgColor ?? UIColor.black.cgColor)
        initValueView(on: soupValueView, value: data.contentValue.soup, color: UIColor.C4?.cgColor ?? UIColor.black.cgColor)
        initValueView(on: happyValueView, value: data.contentValue.happiness, color: UIColor.C4?.cgColor ?? UIColor.black.cgColor)
        
        soupLabel.adjustsFontSizeToFitWidth = true
        noodleLabel.adjustsFontSizeToFitWidth = true
        oveallLabel.adjustsFontSizeToFitWidth = true
        if data.contentValue.soup == 10.0 {
            soupLabel.text = "10"
        } else {
            soupLabel.text = "\(data.contentValue.soup)"
        }
        if data.contentValue.noodle == 10.0 {
            noodleLabel.text = "10"
        } else {
            noodleLabel.text = "\(data.contentValue.noodle)"
        }
        if data.contentValue.happiness == 10.0 {
            oveallLabel.text = "10"
        } else {
            oveallLabel.text = "\(data.contentValue.happiness)"
        }
        
    }
    private func initValueView(on view: UIView, value: Double, color: CGColor) {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint (x: view.frame.size.width / 2,y: view.frame.size.height / 2),
            radius: view.frame.size.width / 2,
            startAngle: CGFloat(-0.5 * .pi),
            endAngle: CGFloat(1.5 * .pi),
            clockwise: true
        )
        // circle shape
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.strokeColor = color
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = 2
        // set start and end values
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = value * 0.1
        // add sublayer
        view.layer.addSublayer(circleShape)
    }
}
