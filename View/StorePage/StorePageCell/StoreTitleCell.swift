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
}
class StoreTitleCell: UITableViewCell {
    weak var delegate: StoreTitleCellDelegate?
    var storedata: Store?
    @IBAction func tapCollectButton(_ sender: UIButton) {
        if collectButton.currentTitle == "已收藏" {
            collectButton.setTitle("收藏", for: .normal)
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
            collectLabel.text = "\(storedata?.collectedUser?.count ?? 1 - 1) 人收藏"
            self.delegate?.didtapUnCollectionButton(view: self)
            
        } else {
            collectButton.setTitle("已收藏", for: .normal)
            collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
            collectLabel.text = "\(storedata?.collectedUser?.count ?? 0 + 1) 人收藏"
            self.delegate?.didtapCollectionButton(view: self)
        }
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectLabel: UILabel!
    
    @IBOutlet weak var collectButton: UIButton!
    
    
    func layoutCell(store: Store?, isCollect: Bool) {
        guard let store = store else {
            return
        }
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
//        collectButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
//        collectButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
//        reportView.layer.cornerRadius = 15
//        reportView.clipsToBounds = true
        mainImageView.kf.setImage(with: URL(string: store.mainImage), placeholder: UIImage(named: "AppIcon"))
        nameLabel.text = store.name
        collectLabel.text = "\(store.collectedUser?.count ?? 0) 人收藏"
//        switch cogfigReport(store: store) {
//        case 0:
//            reportCountLabel.text = "0~5"
//        case 1:
//            reportCountLabel.text = "5~10"
//        case 2:
//            reportCountLabel.text = "10~20"
//        case 3:
//            reportCountLabel.text = "20+"
//        default :
//            reportCountLabel.text = "目前無回報"
//            peopleLabel.isHidden = true
//        }
        
        
    }
    private func cogfigReport(store: Store) -> Int {
        guard let reports = store.queueReport else { return 5 }
        let date = Double(Date().timeIntervalSince1970)
        if !reports.isEmpty {
            guard let report = reports.sorted(by: {$0.createdTime > $1.createdTime}).first else { return 0 }
            if (report.createdTime + 60*60*3) > date {
                return report.queueCount
            } else {
                return 5
            }
        }
        return 5
    }
}
