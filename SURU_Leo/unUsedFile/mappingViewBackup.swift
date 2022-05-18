////
////  MappingViewController.swift
////  SURU_Leo
////
////  Created by LEO W on 2022/4/16.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//import Kingfisher
//
//class MappingViewController: UIViewController {
//    var storeData: [Store] = []
//    var commentData: [Comment] = []
//    // 計算對應的function用
//    var gestureHolder: [UITapGestureRecognizer] = []
//    var storeHolder: [Store] = []
//    
//    // 計算對應的datasource用
//    var distance: [Double] = []
//    var commentOfStore: [[Comment]] = []
//    var selectedIndex = 0 {
//        didSet {
//            if selectedIndex != oldValue {
//                storeCardCollectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredVertically, animated: true)
//            storeCardCollectionView.collectionViewLayout.invalidateLayout()
//            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: storeData[selectedIndex].coordinate.lat-0.002, longitude: storeData[selectedIndex].coordinate.long), latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
////            print(letSelectindexPath())
//            }
//        }
//    }
//    
//    let mapView = MapView()
//    var locationManager = CLLocationManager()
//    
//    //    var collectionViewLayout =  UICollectionViewLayout()
//    var storeCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = "地圖頁"
//        fetchCommentData()
//        fetchStoreData {
//            self.setupMapView()
//            self.setupHiddenCollectionView()
//        }
//        storeCardCollectionView.register(UINib(nibName: String(describing: StoreCardCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StoreCardCell.self))
//        //        collectionViewLayout = generateLayout()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationItem.title = "地圖頁"
//        storeCardCollectionView.dataSource = self
//        storeCardCollectionView.delegate = self
//        storeCardCollectionView.collectionViewLayout = generateLayout()
//        
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        setupLocationManager()
//    }
//    func fetchCommentData() {
//        CommentRequestProvider.shared.fetchComments { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.commentData = data
//                print("Get all comment data from firebase in Mapping page")
//            case .failure(let error):
//                print("Mapping page error with code: \(error)")
//            }
//        }
//    }
//    func fetchStoreData(competion: @escaping () -> Void) {
//        StoreRequestProvider.shared.fetchStores { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.storeData = data.sorted(by: { $0.coordinate.long < $1.coordinate.long
//                })
//                print("Get all store data from firebase in Mapping page")
//            case .failure(let error):
//                print("Mapping page error with code: \(error)")
//            }
//            competion()
//        }
//    }
//    
//    func setupMapView() {
//        self.view.addSubview(mapView)
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        mapView.delegate = self
//        mapView.layoutView(from: storeData)
//    }
//    func setupHiddenCollectionView() {
//        setupDataForCollectionCell()
//        storeCardCollectionView.isHidden = true
//        self.view.addSubview(storeCardCollectionView)
//        storeCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
////        storeCardCollectionView.clipsToBounds = true
//        storeCardCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        storeCardCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
//        storeCardCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        storeCardCollectionView.heightAnchor.constraint(equalTo: storeCardCollectionView.widthAnchor, multiplier: 230/390).isActive = true
//        storeCardCollectionView.backgroundColor = .clear
//    }
//    func setupDescriptionCardView() {
//        
//        
//        if storeCardCollectionView.isHidden {
//            storeCardCollectionView.isHidden = false
//        }
//        
//    }
//    
//    func zoomMapViewin(_ point: Coordinate) {
//        // call mapView function
//    }
//    func setupDataForCollectionCell() {
//        let fakeLocationAkaTaipei101 = CLLocation(latitude: 25.038685278051556, longitude: 121.5323763590289)
//        for (index, data) in storeData.enumerated() {
//            var commentHolder: [Comment] = []
//            distance.append(fakeLocationAkaTaipei101.distance(from: CLLocation(latitude: data.coordinate.lat, longitude: data.coordinate.long)))
//            for comment in commentData where comment.storeID == data.storeID {
//                commentHolder.append(comment)
//            }
//            commentOfStore.insert(commentHolder, at: index)
//        }
//    }
//    
//    func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//        }
//    }
//}
//
//extension MappingViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let imageView: UIImageView = {
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//            imageView.layer.cornerRadius = 15.0
//            imageView.layer.borderWidth = 2.0
//            imageView.layer.borderColor = UIColor.white.cgColor
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            return imageView
//        }()
//        if annotation is MKUserLocation {
//            return nil
//        }
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
//        
//        if annotationView == nil {
//            // create View
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
//        } else {
//            // assign annotation
//            annotationView?.annotation = annotation
//        }
//        // set Image
//        annotationView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        
//        switch annotation.title {
//        default:
//            for store in storeData where annotation.title == store.name {
//                imageView.kf.setImage(with: URL(string: store.mainImage))
//                annotationView?.addSubview(imageView)
//                let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAnnotationView(sender:)))
//                tap.name = store.storeID
//                //                gestureHolder.append(tap)
//                
//                annotationView?.addGestureRecognizer(tap)
//            }
//        }
//        return annotationView
//    }
//    @objc func didTapAnnotationView(sender: UITapGestureRecognizer) {
//        guard let name = sender.name else { return }
//        for (index, store) in storeData.enumerated() where store.storeID == name {
//            
//            selectedIndex = index
//            print(index)
//            setupDescriptionCardView()
//        }
//    }
//}
//extension MappingViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return storeData.count
//    }
//
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(StoreCardCell.self)", for: indexPath) as? StoreCardCell else { return UICollectionViewCell() }
//        
//        cell.layoutCardView(dataSource: storeData[indexPath.row], commentData: commentOfStore[indexPath.row], areaName: "還沒做出來區", distance: distance[indexPath.row])
//        return cell
//    }
//    
//    func generateLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupFractionalWidth = 0.9
//        let groupFractionalHeight = 1
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
//            heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
//        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPagingCentered
//        
//        var layout = UICollectionViewCompositionalLayout(section: section)
//        
//        return layout
//    }
//    func letSelectindexPath() -> Int {
//        
//        for cell in storeCardCollectionView.visibleCells  {
//            guard let cells = cell as? StoreCardCell else { return  0 }
//            if cells.nameLabel.text! == storeData[selectedIndex].name {
//            let row = (storeCardCollectionView.indexPath(for: cell)?.row)!
//            return row
//            }
//        }
//        return 0
//    }
//}
//
//extension MappingViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedIndex = indexPath.row
//        
//        print(indexPath.row + 1)
//    }
//}
//
//
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

//    func setupDataForCollectionCell() {
//        let fakeLocationAkaTaipei101 = CLLocation(latitude: 25.038685278051556, longitude: 121.5323763590289)
//        for (index, data) in storeData.enumerated() {
//            var commentHolder: [Comment] = []
//            distance.append(fakeLocationAkaTaipei101.distance(from: CLLocation(latitude: data.coordinate.lat, longitude: data.coordinate.long)))
//            for comment in commentData where comment.storeID == data.storeID {
//                commentHolder.append(comment)
//            }
//            commentOfStore.insert(commentHolder, at: index)
//        }
//    }
//    func setupDataForFilteredCell() {
//        let fakeLocationAkaTaipei101 = CLLocation(latitude: 25.038685278051556, longitude: 121.5323763590289)
//        for (index, data) in filteredStoreData.enumerated() {
//            var commentHolder: [Comment] = []
//            filteredStoreDistance.append(fakeLocationAkaTaipei101.distance(from: CLLocation(latitude: data.coordinate.lat, longitude: data.coordinate.long)))
//            for comment in commentData where comment.storeID == data.storeID {
//                commentHolder.append(comment)
//            }
//            commentOfFilteredStore.insert(commentHolder, at: index)
//        }
//    }
