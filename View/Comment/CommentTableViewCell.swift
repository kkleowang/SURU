//
//  CommentTableViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/25.
//

import UIKit
import Kingfisher

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    func layoutCommentCell(data: Comment) {
        mainImage.kf.setImage(with: URL(string: data.mainImage))
        storeNameLabel.text = data.storeID
        createTimeLabel.text = String(data.createdTime)
        
    }
    func layoutDraftCell(data: CommentDraft) {
        guard let imageData = data.image else { return }
        mainImage.image = UIImage(data: imageData)
        storeNameLabel.text = data.storeID
        createTimeLabel.text = String(data.createTime)
    }
}
