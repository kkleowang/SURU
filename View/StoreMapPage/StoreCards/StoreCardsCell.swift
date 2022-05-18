//
//  StoreCardsCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/9.
//

import Foundation
import UIKit


protocol StoreCardsCellDelegate: AnyObject {
    func didtapCollectionButton(view: StoreCardsCell, storeID: String)
    func didtapUnCollectionButton(view: StoreCardsCell, storeID: String)
    func didtapCollectionWhenNotLogin(view: StoreCardsCell)
}
class StoreCardsCell: UICollectionViewCell {
    weak var delegate: StoreCardsCellDelegate?
    // MARK: - Property
    private var storeData: Store?
    private var userIsLogin: Bool?
    @IBOutlet weak private var storeImageView: UIImageView!
    @IBOutlet weak private var storeNameLabel: UILabel!
    @IBOutlet weak private var followerLabel: UILabel!
    @IBOutlet weak private var openDayView: UIView!
    @IBOutlet weak private var collectButton: UIButton!
    
    @IBOutlet weak private var mostCommentImageView: UIImageView!
    
    @IBOutlet weak private var soupValueLabel: UILabel!
    @IBOutlet weak private var noodleValueLabel: UILabel!
    @IBOutlet weak private var overallValueLabel: UILabel!
    @IBOutlet weak private var soupView: UIView!
    @IBOutlet weak private var noodleView: UIView!
    @IBOutlet weak private var overallView: UIView!
    
    @IBOutlet weak var nonReportLabel: UILabel!
    @IBOutlet weak private var reportView: UIView!
    @IBOutlet weak private var reportLabel: UILabel!
    @IBOutlet weak private var reportPeopleLabel: UILabel!
    @IBOutlet weak private var reportWaitLabel: UILabel!
    
    
    @IBAction private func tapCollectButton(_ sender: UIButton) {
        guard let userIsLogin = userIsLogin else { return }
        if userIsLogin {
            guard let image = sender.image(for: .normal), let store = storeData else { return }
            if image == UIImage(named: "collect.fill") {
                self.delegate?.didtapUnCollectionButton(view: self, storeID: store.storeID)
            } else {
                self.delegate?.didtapCollectionButton(view: self, storeID: store.storeID)
            }
        } else {
            self.delegate?.didtapCollectionWhenNotLogin(view: self)
        }
    }
    
    
    func layoutCell(storeData: Store, commentData: [Comment], isCollect: Bool, isLogin: Bool) {
        userIsLogin = isLogin
        storeData = storeData
        
        contentView.cornerRadii(radii: 10)
        
        storeImageView.cornerRadii(radii: 25)
        storeImageView.loadImage(storeData.mainImage, placeHolder: UIImage.asset(.mainImage))
        storeImageView.layer.borderWidth = 1.0
        storeImageView.layer.borderColor = UIColor.B6?.cgColor
        
        storeNameLabel.text = storeData.name
        storeNameLabel.adjustsFontSizeToFitWidth = true
        
        followerLabel.text = "\(storeData.collectedUser?.count ?? 0) 人收藏, 共\(commentData.count) 則食記"
        
        openDayView.cornerRadii(radii: 7.5)
        
        if isCollect {
            collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
        } else {
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
        }
        
        mostCommentImageView.cornerRadii(radii: 10)
        
        soupView.cornerRadii(radii: 25)
        noodleView.cornerRadii(radii: 25)
        overallView.cornerRadii(radii: 25)
        
        configOpenDay(storeData.opentime.byPropertyName(weekDay: Date().weekDay()))
        
        var soup: Double = 0
        var noodle: Double = 0
        var happy: Double = 0
        
        if !commentData.isEmpty {
            let mostComment = commentData.sorted(by: {$0.likedUserList.count > $1.likedUserList.count})
            
            mostCommentImageView.kf.setImage(with: URL(string: mostComment[0].mainImage), placeholder: UIImage(named: "noData"))
            
            
            var soup: Double = 0
            var noodle: Double = 0
            var happy: Double = 0
            for comment in commentData {
                noodle += comment.contentValue.noodle
                soup += comment.contentValue.soup
                happy += comment.contentValue.happiness
            }
            let count = Double(commentData.count)
            let data = [(noodle/count).ceiling(toDecimal: 1),
                        (soup/count).ceiling(toDecimal: 1),
                        (happy/count).ceiling(toDecimal: 1)
            ]
            if data[0] == 10.0 {
                noodleValueLabel.text = String(10)
            } else {
                noodleValueLabel.text = String(data[0])
            }
            if data[1] == 10.0 {
                soupValueLabel.text = String(10)
            } else {
                soupValueLabel.text = String(data[1])
            }
            if data[2] == 10.0 {
                overallValueLabel.text = String(10)
            } else {
                overallValueLabel.text = String(data[2])
            }
            
        } else {
            mostCommentImageView.image = UIImage(named: "noData")
            
            soupValueLabel.text = "無"
            soupValueLabel.textColor = .B1
            //            soupLabel.font = .medium(size: 6)
            noodleValueLabel.text = "無"
            noodleValueLabel.textColor = .B1
            //            noodleLabel.font = .medium(size: 6)
            overallValueLabel.text = "無"
            overallValueLabel.textColor = .B1
            //            overallLabel.font = .medium(size: 6)
        }
        reportLabel.textColor = .red
        
        reportLabel.font = .medium(size: 18)
        reportLabel.adjustsFontSizeToFitWidth = true
        reportPeopleLabel.isHidden = false
        reportWaitLabel.isHidden = false
        
        reportLabel.isHidden = false
        nonReportLabel.isHidden = true
        switch cogfigReport(store: storeData) {
        case 1:
            reportLabel.text = "0~5"
        case 2:
            reportLabel.text = "5~10"
        case 3:
            reportLabel.text = "10~20"
        case 4:
            reportLabel.text = "20+"
            
        default :
            
            nonReportLabel.isHidden = false
            reportLabel.isHidden = true
            reportPeopleLabel.isHidden = true
            reportWaitLabel.isHidden = true
        }
        
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
    private func configOpenDay(_ time: Time) {
        if time.lunch == "close" && time.dinner == "close" {
            openDayView.backgroundColor = .systemRed
        } else {
            openDayView.backgroundColor = .systemGreen
        }
    }
}
