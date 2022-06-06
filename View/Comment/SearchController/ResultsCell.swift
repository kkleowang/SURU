//
//  ResultsCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/6.
//

import UIKit

class ResultsCell: UITableViewCell {

    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    func lauoutCell(store: Store) {
        storeImage.cornerRadii(radii: 10)
        storeNameLabel.text = store.name
        storeAddressLabel.text = store.address
        
    }
}
