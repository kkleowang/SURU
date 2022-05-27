//
//  StoreCardViewCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/23.
//

import Cosmos
import Foundation
import Kingfisher
import UIKit

class StoreCardCell: UICollectionViewCell {
    @IBOutlet private var leftImageView: UIImageView! {
        didSet {
            leftImageView.clipsToBounds = true
            leftImageView.layer.cornerRadius = 10
            leftImageView.image = UIImage(named: "man\(Int.random(in: 1 ..< 8))")
        }
    }

    @IBOutlet private var middleImageView: UIImageView! {
        didSet {
            middleImageView.clipsToBounds = true
            middleImageView.layer.cornerRadius = 10
            middleImageView.image = UIImage(named: "man\(Int.random(in: 1 ..< 8))")
        }
    }

    @IBOutlet private var rightImageView: UIImageView! {
        didSet {
            rightImageView.clipsToBounds = true
            rightImageView.layer.cornerRadius = 10
            rightImageView.image = UIImage(named: "man\(Int.random(in: 1 ..< 8))")
        }
    }

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet private var avgRatingView: CosmosView!
    @IBOutlet private var ratingCountLabel: UILabel!
    @IBOutlet private var tagsView: UIStackView!
    @IBOutlet private var localtionAreaLabel: UILabel!
    @IBOutlet private var openingWaringLabel: UILabel!
    @IBOutlet private var timeUntillLabel: UILabel!
    @IBOutlet private var lunchLabel: UILabel!
    @IBOutlet private var dinnerLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!

    func layoutCardView(dataSource: Store, commentData: [Comment], areaName _: String, distance: Double) {
        backgroundColor = .white.withAlphaComponent(0.7)
        clipsToBounds = true
        cornerForAll(radii: 10)
        nameLabel.text = dataSource.name
        localtionAreaLabel.text = dataSource.area
        let weekday = getTodayWeekDay()
        switch weekday {
        case "sun":
            lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.sun.lunch)"
            dinnerLabel.text = "晚餐: \(dataSource.opentime.sun.dinner)"
        case "mon":
            lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.mon.lunch)"
            dinnerLabel.text = "晚餐: \(dataSource.opentime.mon.dinner)"
        case "tue":
            lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.tue.lunch)"
            dinnerLabel.text = "晚餐: \(dataSource.opentime.tue.dinner)"
        case "wed":
            lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.wed.lunch)"
            dinnerLabel.text = "晚餐: \(dataSource.opentime.wed.dinner)"
        case "thu":
            lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.thu.lunch)"
            dinnerLabel.text = "晚餐: \(dataSource.opentime.thu.dinner)"
        case "fri":
            lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.fri.lunch)"
            dinnerLabel.text = "晚餐: \(dataSource.opentime.fri.dinner)"
        case "sat":
            lunchLabel.text = "本日營業時間 中午: \(dataSource.opentime.sat.lunch)"
            dinnerLabel.text = "晚餐: \(dataSource.opentime.sat.dinner)"
        default:
            return
        }
//        var total: Double = 0
//        for data in commentData {
//            let value = (data.contentValue.happiness + data.contentValue.soup + data.contentValue.noodle)/3
//            total += value
//        }
        if !commentData.isEmpty {
            var total: Double = 0
            for data in commentData {
                let value = (data.contentValue.happiness + data.contentValue.soup + data.contentValue.noodle) / 3
                total += value
            }
            ratingCountLabel.text = "\(commentData.count) reviews"
            avgRatingView.rating = total / Double(commentData.count)
        } else {
            ratingCountLabel.text = "no review"
            avgRatingView.rating = 0
        }
//        avgRatingView.rating = total/Double(commentData.count)
        let kilometer = Double(distance / 1000).ceiling(toDecimal: 1)
        distanceLabel.text = String("\(kilometer) 公里")
        if !commentData.isEmpty {
            leftImageView.kf.setImage(with: URL(string: commentData.first!.mainImage))
        }
    }

    func getTodayWeekDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: Date()).lowercased()
        return weekDay
    }
}
