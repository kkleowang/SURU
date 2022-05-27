//
//  CommentTableViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/25.
//

import Kingfisher
import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!

    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var noodleValueView: UIView!
    @IBOutlet weak var soupValueView: UIView!
    @IBOutlet weak var happyValueView: UIView!

    @IBOutlet weak var noodleValueLabel: UILabel!
    @IBOutlet weak var soupValueLabel: UILabel!
    @IBOutlet weak var happyValueLabel: UILabel!

    //    func layoutCommentCell(data: Comment, name: String) {
    //        mainImage.kf.setImage(with: URL(string: data.mainImage))
    //        storeNameLabel.text = name
    //        mealNameLabel.text = data.meal
    //        createTimeLabel.text = String(data.createdTime).toYYYYMMDDHHMM()
    //
    //    }
    func layoutDraftCell(data: CommentDraft, name: String) {
        guard let imageData = data.image, let meal = data.mealName else { return }
        mainImage.image = UIImage(data: imageData)
        noodleValueView.clipsToBounds = true
        soupValueView.clipsToBounds = true
        happyValueView.clipsToBounds = true
        mainImage.clipsToBounds = true
        noodleValueView.layer.cornerRadius = 20
    soupValueView.layer.cornerRadius = 20
        happyValueView.layer.cornerRadius = 20

        mainImage.layer.cornerRadius = 10
        storeNameLabel.text = name
        mealNameLabel.text = meal
        if data.noodleValue == 10.0 {
            noodleValueLabel.text = String(10)
        } else {
            noodleValueLabel.text = String(data.noodleValue)
        }
        if data.soupValue == 10.0 {
            soupValueLabel.text = String(10)
        } else {
            soupValueLabel.text = String(data.soupValue)
        }
        if data.happyValue == 10.0 {
            happyValueLabel.text = String(10)
        } else {
            happyValueLabel.text = String(data.happyValue)
        }


        createTimeLabel.text = String(data.createTime).toYYYYMMDDHHMM()

    }
    //    private func initValueView(on view: UIView, value: Double, color: CGColor) {
    //        // round view
    //            let roundView = UIView(
    //                frame: CGRect(
    //                    x: view.bounds.origin.x,
    //                    y: view.bounds.origin.y,
    //                    width: view.bounds.size.width - 4,
    //                    height: view.bounds.size.height - 4
    //                )
    //            )
    //            roundView.backgroundColor = .B5
    //            roundView.layer.cornerRadius = roundView.frame.size.width / 2
    //
    //            let circlePath = UIBezierPath(arcCenter: CGPoint (x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
    //                                          radius: roundView.frame.size.width / 2,
    //                                          startAngle: CGFloat(-0.5 * .pi),
    //                                          endAngle: CGFloat(1.5 * .pi),
    //                                          clockwise: true)
    //            let circleShape = CAShapeLayer()
    //            circleShape.path = circlePath.cgPath
    //            circleShape.strokeColor = color
    //            circleShape.fillColor = UIColor.clear.cgColor
    //            circleShape.lineWidth = 4
    //            // set start and end values
    //            circleShape.strokeStart = 0.0
    //        circleShape.strokeEnd = value*0.1
    //
    //            // add sublayer
    //            roundView.layer.addSublayer(circleShape)
    //            // add subview
    //            view.addSubview(roundView)
    //        view.backgroundColor = .clear
    //    }
}
