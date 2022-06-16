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
        storeImage.addCircle(color: UIColor.B1?.cgColor ?? UIColor.black.cgColor)
        storeImage.loadImage(store.mainImage)
        storeNameLabel.text = store.name
        storeAddressLabel.text = store.address
        if let localtion = CoreLocationManager.shared.currentLocation?.coordinate {
            print(localtion)
            let postiiton = CLLocation(latitude: localtion.latitude, longitude: localtion.longitude)
//            let local = CLLocation(latitude: 25.0856314, longitude: 121.5968892)
            let distance = postiiton.distance(from: CLLocation(latitude: store.coordinate.lat, longitude: store.coordinate.long))
            let km = ( distance / 1000 ).ceiling(toDecimal: 2)
            print(localtion, distance, km)
        storeDistanceLabel.text = "距離 \(km) 公里"
        } else {
            storeDistanceLabel.text = ""
        }
    }
}
