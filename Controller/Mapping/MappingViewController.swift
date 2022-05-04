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
    var commentData: [Comment] = []
    // 計算對應的function用
    var gestureHolder: [UITapGestureRecognizer] = []
    var storeHolder: [Store] = []
//    let view = UIImageView()
//    let pan = UIPanGestureRecognizer()
//    pan.addTarget(self, action: #s)
    // 計算對應的datasource用
    var distance: [Double] = []
    var commentOfStore: [[Comment]] = []
    var selectedIndex = 0 {
        didSet {
            print(selectedIndex)
            
            storeCardCollectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: storeData[selectedIndex].coordinate.lat-0.002, longitude: storeData[selectedIndex].coordinate.long), latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
            
        }
    }
    
    let mapView = MapView()
    //    var locationManager = CLLocationManager()
    var storeCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCommentData()
        fetchStoreData {
            self.setupMapView()
            self.setupHiddenCollectionView()
        }
        storeCardCollectionView.dataSource = self
        storeCardCollectionView.delegate = self
        if let flowLayout = storeCardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        storeCardCollectionView.register(UINib(nibName: String(describing: StoreCardCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StoreCardCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        setupLocationManager()
    }
    func fetchCommentData() {
        CommentRequestProvider.shared.fetchComments { [weak self] result in
            switch result {
            case .success(let data):
                self?.commentData = data
                print("Get all comment data from firebase in Mapping page")
            case .failure(let error):
                print("Mapping page error with code: \(error)")
            }
        }
    }
    func fetchStoreData(competion: @escaping () -> Void) {
        StoreRequestProvider.shared.fetchStores { [weak self] result in
            switch result {
            case .success(let data):
                self?.storeData = data.sorted(by: { $0.coordinate.long < $1.coordinate.long
                })
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
    func setupHiddenCollectionView() {
        setupDataForCollectionCell()
        storeCardCollectionView.isHidden = true
        self.view.addSubview(storeCardCollectionView)
        storeCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        storeCardCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        storeCardCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        storeCardCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        storeCardCollectionView.heightAnchor.constraint(equalTo: storeCardCollectionView.widthAnchor, multiplier: 230/390).isActive = true
        storeCardCollectionView.backgroundColor = .clear
    }
    func setupDescriptionCardView() {
        if storeCardCollectionView.isHidden {
            storeCardCollectionView.isHidden = false
            
        }
    }
    
    func zoomMapViewin(_ point: Coordinate) {
        // call mapView function
    }
    func setupDataForCollectionCell() {
        let fakeLocationAkaTaipei101 = CLLocation(latitude: 25.038685278051556, longitude: 121.5323763590289)
        for (index, data) in storeData.enumerated() {
            var commentHolder: [Comment] = []
            distance.append(fakeLocationAkaTaipei101.distance(from: CLLocation(latitude: data.coordinate.lat, longitude: data.coordinate.long)))
            for comment in commentData where comment.storeID == data.storeID {
                commentHolder.append(comment)
            }
            commentOfStore.insert(commentHolder, at: index)
        }
    }
    
    //    func setupLocationManager() {
    //        locationManager.delegate = self
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.requestAlwaysAuthorization()
    //
    //        if CLLocationManager.locationServicesEnabled() {
    //            locationManager.startUpdatingLocation()
    //        }
    //    }
}

extension MappingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.layer.cornerRadius = 20
            imageView.layer.borderWidth = 2.0
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
        annotationView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        switch annotation.title {
        default:
            for store in storeData where annotation.title == store.name {
                imageView.kf.setImage(with: URL(string: store.mainImage))
                annotationView?.addSubview(imageView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAnnotationView(sender:)))
                tap.name = store.storeID
                //                gestureHolder.append(tap)
                
                annotationView?.addGestureRecognizer(tap)
            }
        }
        return annotationView
    }
    @objc func didTapAnnotationView(sender: UITapGestureRecognizer) {
        guard let name = sender.name else { return }
        for (index, store) in storeData.enumerated() where store.storeID == name {
            selectedIndex = index
            setupDescriptionCardView()
        }
    }
}
extension MappingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(StoreCardCell.self)", for: indexPath) as? StoreCardCell else { return UICollectionViewCell() }
        
        cell.layoutCardView(dataSource: storeData[indexPath.row], commentData: commentOfStore[indexPath.row], areaName: "還沒做出來區", distance: distance[indexPath.row])
        return cell
    }
}

extension MappingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mapView.view(for: mapView.annotations[indexPath.row])?.doGlowAnimation(withColor: .red, withEffect: .mid)
    }
     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemSize = CGSize(width: self.storeCardCollectionView.frame.size.width - 2 * 16, height: self.storeCardCollectionView.frame.size.height - 2 * 6)
        let xCenterOffset = targetContentOffset.pointee.x + (itemSize.width / 2.0)
        let indexPath = IndexPath(item: Int(xCenterOffset / (itemSize.width + 16 / 2.0)), section: 0)
         self.selectedIndex = indexPath.row
        let offset = CGPoint(x: (itemSize.width + 16.0 / 2.0*2) * CGFloat(indexPath.item), y: 0)
        targetContentOffset.pointee = offset
         
    }
}
extension MappingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size
        let cellSize = CGSize(width: collectionViewSize.width - 2 * 16.0, height: collectionViewSize.height - 2 * 6.0)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0)
    }
    
}

//extension MappingViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation: CLLocation = locations[0] as CLLocation
//        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        mapView.setRegion(mRegion, animated: true)
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error - locationManager: \(error.localizedDescription)")
//    }
//}
