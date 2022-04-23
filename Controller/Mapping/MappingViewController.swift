//
//  MappingViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit
import MapKit
import CoreLocation
import Kingfisher

class MappingViewController: UIViewController {
    var storeData: [Store] = []
    //計算對應的function用
    var gestureHolder: [UITapGestureRecognizer] = []
    var storeHolder: [Store] = []
    
    let mapView = MapView()
    var locationManager = CLLocationManager()
    
    //    var collectionViewLayout =  UICollectionViewLayout()
    var storeCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "地圖頁"
        fetchData {
            self.setupMapView()
        }
        storeCardCollectionView.register(UINib(nibName: String(describing: StoreCardCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StoreCardCell.self))
        //        collectionViewLayout = generateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "地圖頁"
        storeCardCollectionView.dataSource = self
        storeCardCollectionView.collectionViewLayout = generateLayout()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocationManager()
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
        
        storeCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.stickSubView(storeCardCollectionView, inset: UIEdgeInsets(top: 50, left: 20, bottom: 600, right: 20))
    }
    
    func zoomMapViewin(_ to: Coordinate) {
        //call mapView function
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
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
extension MappingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(StoreCardCell.self)", for: indexPath) as! StoreCardCell
        let distanceArray: [Double] = {
            var array: [Double] = []
            for store in self.storeData {
                array.append((MKUserLocation().location?.distance(from: CLLocation(latitude: store.coordinate.lat, longitude: store.coordinate.long))) ?? 123)
            }
            return array
        }()
        
        cell.layoutCardView(dataSource: storeData[indexPath.row], areaName: "還沒做出來區", distance: distanceArray[indexPath.row])
        return cell
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupFractionalWidth = 0.9
        let groupFractionalHeight = 1
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
            heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
extension MappingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(mRegion, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}
