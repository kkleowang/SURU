//
//  StoreTitleCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit
import Kingfisher

protocol StoreTitleCellDelegate: AnyObject {
    func didtapCollectionButton(view: StoreTitleCell)
    func didtapUnCollectionButton(view: StoreTitleCell)
    func didtapWhenNotLogin(view: StoreTitleCell)
}
class StoreTitleCell: UITableViewCell {
    weak var delegate: StoreTitleCellDelegate?
    var storedata: Store?
    @IBAction func tapCollectButton(_ sender: UIButton) {
        guard let isLogin = isUserLogin else { return }
        
        if isLogin {
            if collectButton.currentTitle == "已收藏" {
                self.delegate?.didtapUnCollectionButton(view: self)
                collectButton.setTitle("收藏", for: .normal)
                collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
                collectLabel.text = "\(storedata?.collectedUser?.count ?? 1 - 1) 人收藏"
            } else {
                self.delegate?.didtapCollectionButton(view: self)
                collectButton.setTitle("已收藏", for: .normal)
                collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
                collectLabel.text = "\(storedata?.collectedUser?.count ?? 0 + 1) 人收藏"
                
            }
        } else {
            self.delegate?.didtapWhenNotLogin(view: self)
        }
    }

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectLabel: UILabel!

    @IBOutlet weak var collectButton: UIButton!
    var isUserLogin: Bool?
    var isUserCollect: Bool?

    func layoutCell(store: Store?, isCollect: Bool, isLogin: Bool) {
        guard let store = store else {
            return
        }
        isUserCollect = isCollect
        isUserLogin = isLogin
        storedata = store
        if isLogin {
            if isCollect {
                collectButton.setTitle("已收藏", for: .normal)
                collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
            } else {
                collectButton.setTitle("收藏", for: .normal)
                collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
            }
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
