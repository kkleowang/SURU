//
//  StoreLocaltionCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import MapKit
import UIKit

class StoreLocaltionCell: UITableViewCell {
    var localtionText: String = ""
    @IBOutlet var iconImageView: UIImageView!

    @IBOutlet var mapButton: UIButton!
    @IBOutlet var label: UILabel!

    @IBAction func tapMap(_: Any) {
        UIPasteboard.general.string = localtionText
        LKProgressHUD.showSuccess(text: "已複製地址")
    }

    func layoutCell(localtion: String? = "", seat: String? = "") {
        selectionStyle = .none
        guard let localtion = localtion, let seat = seat else {
            return
        }
        label.adjustsFontSizeToFitWidth = true
        if localtion != "" {
            localtionText = localtion
            label.text = localtion
            iconImageView.image = UIImage(named: "pin")
        } else {
            mapButton.isHidden = true
            iconImageView.image = UIImage(named: "chair")
            if seat.count >= 5 {
                label.text = seat
            } else {
                label.text = "座位數共約\(seat)席"
            }
        }
    }
}
