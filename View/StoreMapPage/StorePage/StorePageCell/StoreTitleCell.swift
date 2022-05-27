//
//  StoreTitleCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import Kingfisher
import UIKit

protocol StoreTitleCellDelegate: AnyObject {
    func didtapCollectionButton(view: StoreTitleCell)
    func didtapUnCollectionButton(view: StoreTitleCell)
    func didtapWhenNotLogin(view: StoreTitleCell)
}

class StoreTitleCell: UITableViewCell {
    weak var delegate: StoreTitleCellDelegate?
    var storedata: Store?
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var collectLabel: UILabel!

    @IBOutlet var collectButton: UIButton!

    @IBAction func tapCollectButton(_: UIButton) {
        if collectButton.currentTitle == "已收藏" {
            delegate?.didtapUnCollectionButton(view: self)
            collectButton.setTitle("收藏", for: .normal)
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
            collectLabel.text = "\(storedata?.collectedUser?.count ?? 1 - 1) 人收藏"
        } else {
            delegate?.didtapCollectionButton(view: self)
            collectButton.setTitle("已收藏", for: .normal)
            collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
            collectLabel.text = "\(storedata?.collectedUser?.count ?? 0 + 1) 人收藏"
        }
    }

    var isUserCollect: Bool?

    func layoutCell(store: Store?, isCollect: Bool) {
        selectionStyle = .none
        guard let store = store else {
            return
        }
        isUserCollect = isCollect
        storedata = store
        if isCollect {
            collectButton.setTitle("已收藏", for: .normal)
            collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
        } else {
            collectButton.setTitle("收藏", for: .normal)
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
        }
        collectButton.layer.cornerRadius = 10
        collectButton.clipsToBounds = true
        collectButton.layer.borderWidth = 1
        collectButton.layer.borderColor = UIColor.B1?.cgColor
        mainImageView.addCircle(color: UIColor.white.cgColor)
        mainImageView.kf.setImage(with: URL(string: store.mainImage), placeholder: UIImage(named: "mainImage"))
        nameLabel.text = store.name
        nameLabel.adjustsFontSizeToFitWidth = true
        collectLabel.text = "\(store.collectedUser?.count ?? 0) 人收藏"
    }
}
