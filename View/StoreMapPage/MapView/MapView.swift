//
//  MapView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import Kingfisher
import MapKit
import UIKit

class MapView: MKMapView {
    func layoutView(from stores: [Store]) {
        if !stores.isEmpty {
            for store in stores {
                let mark = MKPointAnnotation()
                mark.coordinate = CLLocationCoordinate2D(latitude: store.coordinate.lat, longitude: store.coordinate.long)
                mark.title = store.name
                addAnnotation(mark)
            }
        }
    }
}
