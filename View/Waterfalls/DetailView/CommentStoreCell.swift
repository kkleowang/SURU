//
//  CommentStoreCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import Kingfisher
import MapKit
import UIKit
protocol CommentStoreCellDelegate: AnyObject {
    func didTapCollectStore(_ view: CommentStoreCell, storeID: String)
}

class CommentStoreCell: UITableViewCell {
    weak var delegate: CommentStoreCellDelegate?
    var storeData: Store?

    @IBOutlet var mapView: UIView!
    @IBAction func tapCollectButton(_: Any) {
        guard let storeData = storeData else {
            return
        }

        delegate?.didTapCollectStore(self, storeID: storeData.storeID)
    }

    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var storeImageView: UIImageView!

    func layoutCell(store: Store) {
        storeData = store
        storeNameLabel.text = store.name
        storeImageView.kf.setImage(with: URL(string: store.mainImage))
        let long = store.coordinate.long
        let lat = store.coordinate.lat
        let MKmap = MKMapView()
        mapView.addSubview(MKmap)
        MKmap.translatesAutoresizingMaskIntoConstraints = false
        MKmap.topAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
        MKmap.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        MKmap.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive = true
        MKmap.trailingAnchor.constraint(equalTo: mapView.trailingAnchor).isActive = true

        MKmap.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: 400, longitudinalMeters: 400)

        let mark = MKPointAnnotation()
        mark.coordinate = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long
        )
        mark.title = store.name
        MKmap.addAnnotation(mark)
    }
}
