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

    private var store: Store?
    private var userIsLogin: Bool?

    @IBOutlet private var storeImageView: UIImageView!
    @IBOutlet private var storeNameLabel: UILabel!
    @IBOutlet private var followerLabel: UILabel!
    @IBOutlet private var openDayView: UIView!
    @IBOutlet private var collectButton: UIButton!

    @IBOutlet private var mostCommentImageView: UIImageView!

    @IBOutlet private var soupValueLabel: UILabel!
    @IBOutlet private var noodleValueLabel: UILabel!
    @IBOutlet private var overallValueLabel: UILabel!
    @IBOutlet private var soupView: UIView!
    @IBOutlet private var noodleView: UIView!
    @IBOutlet private var overallView: UIView!

    @IBOutlet var nonReportLabel: UILabel!
    @IBOutlet private var reportView: UIView!
    @IBOutlet private var reportLabel: UILabel!
    @IBOutlet private var reportPeopleLabel: UILabel!
    @IBOutlet private var reportWaitLabel: UILabel!

    @IBAction private func tapCollectButton(_ sender: UIButton) {
        guard let userIsLogin = userIsLogin else { return }
        if userIsLogin {
            guard let image = sender.image(for: .normal), let store = store else { return }
            if image == UIImage(named: "collect.fill") {
                delegate?.didtapUnCollectionButton(view: self, storeID: store.storeID)
            } else {
                delegate?.didtapCollectionButton(view: self, storeID: store.storeID)
            }
        } else {
            delegate?.didtapCollectionWhenNotLogin(view: self)
        }
    }

    func layoutCell(storeData: Store, commentData: [Comment], report: Int, isCollect: Bool, isLogin: Bool) {
        userIsLogin = isLogin
        store = storeData

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
        configAvgRating(commentData)
        configRepoet(report)
        let mostImage = commentData.sorted { $0.likedUserList.count > $1.likedUserList.count }.first?.mainImage
        mostCommentImageView.loadImage(mostImage, placeHolder: UIImage.asset(.noData))
    }

    private func configOpenDay(_ time: Time) {
        if time.lunch == "close", time.dinner == "close" {
            openDayView.backgroundColor = .systemRed
        } else {
            openDayView.backgroundColor = .systemGreen
        }
    }

    private func configAvgRating(_ comments: [Comment]) {
        if !comments.isEmpty {
            let count = Double(comments.count)
            let noodle: Double = comments.map { $0.contentValue.noodle }.reduce(0, +)
            let soup: Double = comments.map { $0.contentValue.soup }.reduce(0, +)
            let overall: Double = comments.map { $0.contentValue.happiness }.reduce(0, +)

            let noodleAvg = (noodle / count).ceiling(toDecimal: 1)
            let soupAvg = (soup / count).ceiling(toDecimal: 1)
            let overallAvg = (overall / count).ceiling(toDecimal: 1)

            if noodleAvg >= 10.0 {
                noodleValueLabel.text = String(10)
            } else {
                noodleValueLabel.text = String(noodleAvg)
            }
            if soupAvg >= 10.0 {
                soupValueLabel.text = String(10)
            } else {
                soupValueLabel.text = String(soupAvg)
            }
            if overallAvg >= 10.0 {
                overallValueLabel.text = String(10)
            } else {
                overallValueLabel.text = String(overallAvg)
            }
        } else {
            soupValueLabel.text = "無"
            noodleValueLabel.text = "無"
            overallValueLabel.text = "無"
        }
    }

    private func configRepoet(_ report: Int) {
        reportLabel.textColor = .red
        reportLabel.font = .medium(size: 18)
        reportLabel.adjustsFontSizeToFitWidth = true
        reportPeopleLabel.isHidden = false
        reportWaitLabel.isHidden = false
        reportLabel.isHidden = false
        nonReportLabel.isHidden = true

        switch report {
        case 1:
            reportLabel.text = "0~5"
        case 2:
            reportLabel.text = "5~10"
        case 3:
            reportLabel.text = "10~20"
        case 4:
            reportLabel.text = "20+"
        default:
            reportPeopleLabel.isHidden = true
            reportWaitLabel.isHidden = true
            reportLabel.isHidden = true
            nonReportLabel.isHidden = false
        }
    }
}
