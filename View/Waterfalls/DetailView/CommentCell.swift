//
//  CommentCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import Kingfisher
import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet var noodleValueView: UIView!
    @IBOutlet var soupValueView: UIView!
    @IBOutlet var happyValueView: UIView!
    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var sideDishesLabel: UILabel!
    
    @IBOutlet var mealLabel: UILabel!
    
    @IBOutlet var noodleLabel: UILabel!
    @IBOutlet var soupLabel: UILabel!
    @IBOutlet var oveallLabel: UILabel!
    
    @IBOutlet var contentTextView: UITextView!
    
    func layoutCell(data: Comment, store: Store) {
        for view in [noodleValueView, soupValueView, happyValueView] {
            view?.clipsToBounds = true
            view?.layer.cornerRadius = 60 / 2
        }
        mainImageView.cornerRadii(radii: 10)
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
        noodleValueView.initValueCircle(value: data.contentValue.noodle, color: UIColor.C4?.cgColor ?? UIColor.black.cgColor)
        soupValueView.initValueCircle(value: data.contentValue.soup, color: UIColor.C4?.cgColor ?? UIColor.black.cgColor)
        happyValueView.initValueCircle(value: data.contentValue.happiness, color: UIColor.C4?.cgColor ?? UIColor.black.cgColor)
        
        soupLabel.adjustsFontSizeToFitWidth = true
        noodleLabel.adjustsFontSizeToFitWidth = true
        oveallLabel.adjustsFontSizeToFitWidth = true
        
        soupLabel.text = "\(data.contentValue.soup)"
        
        noodleLabel.text = "\(data.contentValue.noodle)"
        
        oveallLabel.text = "\(data.contentValue.happiness)"
        
    }
}
