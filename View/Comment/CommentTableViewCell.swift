//
//  CommentTableViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/25.
//

import Kingfisher
import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet var mainImage: UIImageView!
    
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var mealNameLabel: UILabel!
    @IBOutlet var createTimeLabel: UILabel!
    @IBOutlet var noodleValueView: UIView!
    @IBOutlet var soupValueView: UIView!
    @IBOutlet var happyValueView: UIView!
    
    @IBOutlet var noodleValueLabel: UILabel!
    @IBOutlet var soupValueLabel: UILabel!
    @IBOutlet var happyValueLabel: UILabel!
    
    //    func layoutCommentCell(data: Comment, name: String) {
    //        mainImage.kf.setImage(with: URL(string: data.mainImage))
    //        storeNameLabel.text = name
    //        mealNameLabel.text = data.meal
    //        createTimeLabel.text = String(data.createdTime).toYYYYMMDDHHMM()
    //
    //    }
    func layoutDraftCell(data: CommentDraft, name: String) {
        selectionStyle = .none
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
        
        noodleValueLabel.text = String(data.noodleValue)
        
        soupValueLabel.text = String(data.soupValue)
        
        happyValueLabel.text = String(data.happyValue)
        
        
        createTimeLabel.text = String(data.createTime).toYYYYMMDDHHMM()
    }
}
