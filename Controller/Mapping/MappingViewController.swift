//
//  MappingViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit
import MapKit
import Kingfisher

class MappingViewController: UIViewController {
    var storeData: [Store] = []
    var gestureHolder: [UITapGestureRecognizer] = []
    var storeHolder: [Store] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "地圖頁"
        fetchData {
            self.setupMapView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "地圖頁"
    }
    
    func fetchData(competion: @escaping () -> Void) {
        StoreRequestProvider.shared.fetchStores { [weak self] result in
            switch result {
            case .success(let data):
                self?.storeData = data
                print("Get all store data from firebase in Mapping page")
            case .failure(let error):
                print("Mapping page error with code: \(error)")
            }
            competion()
        }
    }
    
    func setupMapView() {
        let mapView = MapView()
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.delegate = self
        mapView.layoutView(from: storeData)
    }
    
    func setupDescriptionCardView(_ store: Store) {
        //init newView
    }
    
    func zoomMapViewin(_ to: Coordinate) {
        //call mapView function
    }
}

extension MappingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 25.0
            imageView.layer.borderWidth = 3.0
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            // create View
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            // assign annotation
            annotationView?.annotation = annotation
        }
        // set Image
        annotationView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        switch annotation.title {
        default:
            for store in storeData where annotation.title == store.name {
                imageView.kf.setImage(with: URL(string: store.mainImage))
                annotationView?.addSubview(imageView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAnnotationView(sender:)))
                gestureHolder.append(tap)
                storeHolder.append(store)
                annotationView?.addGestureRecognizer(tap)
            }
        }
        return annotationView
    }
    @objc func didTapAnnotationView(sender: UITapGestureRecognizer) {
        let index = gestureHolder.firstIndex(of: sender)
        guard let index = index else {
            return
        }
        setupDescriptionCardView(storeHolder[index])
    }
}
