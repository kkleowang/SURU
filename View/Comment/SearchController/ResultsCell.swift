//
//  ResultsCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/6.
//

import UIKit
import CoreLocation

class ResultsCell: UITableViewCell {

    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    
    func layoutCell(store: Store) {
        storeImage.cornerRadii(radii: 10)
        storeNameLabel.text = store.name
        storeAddressLabel.text = store.address
        if let localtion = CoreLocationManager.shared.currentLocation {
            let distance = localtion.distance(from: CLLocation(latitude: store.coordinate.lat, longitude: store.coordinate.long))
            
        storeDistanceLabel.text = "距離 \(distance) 公里"
        }
    }
}
