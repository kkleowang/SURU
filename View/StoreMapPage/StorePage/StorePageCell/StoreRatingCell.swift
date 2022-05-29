//
//  StoreRatingCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit

class StoreRatingCell: UITableViewCell {
    @IBOutlet var soupView: UIView!
    @IBOutlet var noodleView: UIView!
    @IBOutlet var overallView: UIView!
    
    @IBOutlet var soupValueLabel: UILabel!
    @IBOutlet var noodleValueLabel: UILabel!
    @IBOutlet var overallValueLabel: UILabel!
    
    func layoutCell(comments: [Comment]) {
        selectionStyle = .none
        soupView.cornerRadii(radii: soupView.bounds.width / 2)
        noodleView.cornerRadii(radii: noodleView.bounds.width / 2)
        overallView.cornerRadii(radii: overallView.bounds.width / 2)
        soupView.backgroundColor = .main1
        noodleView.backgroundColor = .main2
        overallView.backgroundColor = .main3
        
        configAvgRating(comments)
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
            
            noodleValueLabel.text = String(noodleAvg)
            
            soupValueLabel.text = String(soupAvg)
            
            overallValueLabel.text = String(overallAvg)
            
        } else {
            soupValueLabel.text = "無"
            noodleValueLabel.text = "無"
            overallValueLabel.text = "無"
        }
    }
}
