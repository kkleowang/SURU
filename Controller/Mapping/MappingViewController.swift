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
    private var isLogin = true
    private var commentData: [Comment] = []
    private var currentUser: Account?
    private var reportButton = UIButton()
    private let locationManager = CLLocationManager()
    private let mapView = MapView()
    private lazy var searchBar: UISearchBar = UISearchBar()
    
    // 計算對應的function用
    private var gestureHolder: [UITapGestureRecognizer] = []
    
    private var isSearchResults = false
    
    private var storeData: [Store] = [] {
        didSet {
            storeData = storeData.sorted(by: { $0.coordinate.long < $1.coordinate.long})
        }
    }
    private var filteredStoreData: [Store] = []
    
    
    private var storeTag: [String] = []
    
//    private var commentOfStore: [[Comment]] = []
//    private var commentOfFilteredStore: [[Comment]] = []
    
    
    private var distance: [Double] = []
    private var filteredStoreDistance: [Double] = []
    
    
    // collectionView
    private var storeCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    //    private var tagSelectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var selectedIndex = 0 {
        didSet {
            if isSearchResults {
                print(selectedIndex)
                storeCardCollectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                let locationPoint = CLLocationCoordinate2D(latitude: filteredStoreData[selectedIndex].coordinate.lat - 0.002, longitude: filteredStoreData[selectedIndex].coordinate.long)
                mapView.setRegion(MKCoordinateRegion(center: locationPoint, latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
            } else {
                print(selectedIndex)
                storeCardCollectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                let locationPoint = CLLocationCoordinate2D(latitude: storeData[selectedIndex].coordinate.lat - 0.002, longitude: storeData[selectedIndex].coordinate.long)
                mapView.setRegion(MKCoordinateRegion(center: locationPoint, latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserRequestProvider.shared.currentUserID == nil {
            isLogin = false
        }
        listenAccount()
        listenAllComment()
        self.listenLoginState()
        StoreRequestProvider.shared.listenStore {
            self.updataStore()
        }
        //        setupLocationManager()
        self.view.stickSubView(mapView)
        storeCardCollectionView.isHidden = true
        
        fetchData(isLogin: isLogin) {
            LKProgressHUD.showSuccess(text: "下載資料成功")
            self.setupSearchBar()
            self.setupMapView()
            self.setupHiddenCollectionView()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        storeCardCollectionView.reloadData()
        reloadMapView()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.09108, longitude: 121.5598), latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: true)
        mapView.layoutView(from: storeData)
    }
    private func setupHiddenCollectionView() {
//        setupDataForCollectionCell()
        if let flowLayout = storeCardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        storeCardCollectionView.register(UINib(nibName: String(describing: StoreCardsCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StoreCardsCell.self))
        storeCardCollectionView.dataSource = self
        storeCardCollectionView.delegate = self
        self.view.addSubview(storeCardCollectionView)
        storeCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        storeCardCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        storeCardCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        storeCardCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        storeCardCollectionView.heightAnchor.constraint(equalTo: storeCardCollectionView.widthAnchor, multiplier: 230/390).isActive = true
        storeCardCollectionView.backgroundColor = .clear
    }
    private func setupDescriptionCardView() {
        if storeCardCollectionView.isHidden {
            storeCardCollectionView.isHidden = false
            addDragFloatBtn()
        }
        if reportButton.isHidden {
            reportButton.isHidden = false
        }
    }
    private func updataStore() {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case .success(let data) :
                print("監聽商店成功 地圖頁面", data.count)
                self.storeData = data
                if self.isSearchResults {
                    let text = self.searchBar.text ?? ""
                    self.filteredStoreData = self.storeData.filter({ store in
                        let tag = store.tags.joined()
                        let title = store.name
                        let address = store.address
                        
                        let isMatchTags = tag.localizedStandardContains(text)
                        let isMatchName = title.localizedStandardContains(text)
                        let isMatchAddress = address.localizedStandardContains(text)
                        if isMatchTags || isMatchName || isMatchAddress == true {
                            return true
                        } else {
                            return false
                        }
                    })
                }
                self.storeCardCollectionView.reloadData()
                self.reloadMapView()
            case .failure(let error) :
                print("下載商店資料失敗", error)
            }
        }
    }
    private func listenAccount() {
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        AccountRequestProvider.shared.listenAccount(currentUserID: userID) { result in
            switch result {
            case .success(let data) :
                print("監聽登入使用者成功", data.userID)
                self.currentUser = data
            case .failure(let error) :
                print("載入監聽評論失敗 地圖頁面失敗", error)
                
            }
        }
    }
    private func listenAllComment() {
        CommentRequestProvider.shared.listenAllComment { result in
            switch result {
            case .success(let data) :
                print("監聽評論成功 地圖頁面", data.count)
                self.commentData = data
            case .failure(let error) :
                print("載入監聽評論失敗 地圖頁面失敗", error)
                
            }
        }
    }
    private func listenLoginState() {
        UserRequestProvider.shared.listenFirebaseLoginSendAccount { result in
            switch result {
            case .success(let data) :
                print("監聽使用者成功 地圖頁面", data?.userID)
                self.isLogin = true
                self.currentUser = data
//                self.storeCardCollectionView.reloadData()
            case .failure(let error) :
                print("載入使用者失敗", error)
                self.isLogin = false
                self.currentUser = nil
//                self.storeCardCollectionView.reloadData()
                LKProgressHUD.dismiss()
                LKProgressHUD.showFailure(text: "載入使用者失敗")
            }
        }
        
    }
    private func fetchData(isLogin: Bool, competion: @escaping () -> Void) {
        let group: DispatchGroup = DispatchGroup()
        let concurrentQueue1 = DispatchQueue(label: "com.leowang.queue1", attributes: .concurrent)
        let concurrentQueue2 = DispatchQueue(label: "com.leowang.queue2", attributes: .concurrent)
        let concurrentQueue3 = DispatchQueue(label: "com.leowang.queue3", attributes: .concurrent)
        LKProgressHUD.show(text: "下載店家資訊中")
        group.enter()
        concurrentQueue1.async(group: group) {
            StoreRequestProvider.shared.fetchStores { result in
                switch result {
                case .success(let data) :
                    self.storeData = data
                case .failure(let error) :
                    print("下載商店資料失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載商店資料失敗")
                }
                group.leave()
            }
        }
        group.enter()
        concurrentQueue2.async(group: group) {
            CommentRequestProvider.shared.fetchComments { result in
                switch result {
                case .success(let data) :
                    self.commentData = data
                case .failure(let error) :
                    print("下載評論失敗", error)
                    LKProgressHUD.dismiss()
                    LKProgressHUD.showFailure(text: "下載評論失敗")
                }
                group.leave()
            }
        }
        if UserRequestProvider.shared.currentUserID != nil {
            group.enter()
            concurrentQueue3.async(group: group) {
                guard let currentUserID = UserRequestProvider.shared.currentUserID else { return }
                AccountRequestProvider.shared.fetchAccount(currentUserID: currentUserID) { result in
                    switch result {
                    case .success(let data) :
                        self.currentUser = data
                    case .failure(let error) :
                        print("載入使用者失敗", error)
                        LKProgressHUD.dismiss()
                        LKProgressHUD.showFailure(text: "載入使用者失敗")
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            LKProgressHUD.dismiss()
            competion()
        }
    }
    
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
    func setupSearchBar() {
        searchBar.tintColor = .B1
        searchBar.searchTextField.autocorrectionType = .no
        searchBar.returnKeyType = .search
        searchBar.placeholder = " Search..."
        searchBar.isTranslucent = false
        searchBar.enablesReturnKeyAutomatically = false
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            //textField.font = myFont
            //textField.textColor = myTextColor
            //textField.tintColor = myTintColor
            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) {
                backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() })
            }
            backgroundView?.layer.cornerRadius = 10.5
            backgroundView?.layer.masksToBounds = true
        }
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            // 他沒打開
            print("Map not open")
            
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            followUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show alert
            break
        case .authorizedAlways:
            break
        }
    }
    func followUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MappingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let viewSize = 50.0
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: viewSize, height: viewSize))
            imageView.layer.cornerRadius = viewSize / 2
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
        annotationView?.frame = CGRect(x: 0, y: 0, width: viewSize, height: viewSize)
        
        switch annotation.title {
        default:
            for store in storeData where annotation.title == store.name {
                switch cogfigReport(store: store) {
                case 1:
                    annotationView?.doGlowAnimation(withColor: .blue, withEffect: .small)
                case 2:
                    annotationView?.doGlowAnimation(withColor: .green, withEffect: .normal)
                case 3:
                    annotationView?.doGlowAnimation(withColor: .orange, withEffect: .mid)
                case 4:
                    annotationView?.doGlowAnimation(withColor: .red, withEffect: .big)
                default:
                    break
                }
                
                imageView.kf.setImage(with: URL(string: store.mainImage), placeholder: UIImage(named: "mainImage") )
                annotationView?.subviews.forEach { $0.removeFromSuperview() }
                annotationView?.addSubview(imageView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAnnotationView(sender:)))
                tap.name = store.storeID
                gestureHolder.append(tap)
                annotationView?.addGestureRecognizer(tap)
            }
        }
        return annotationView
    }
    @objc func didTapAnnotationView(sender: UITapGestureRecognizer) {
        searchBar.endEditing(true)
        guard let name = sender.name else { return }
        if isSearchResults {
            for (index, store) in filteredStoreData.enumerated() where store.storeID == name {
                selectedIndex = index
                print("搜尋地圖手勢", index)
                setupDescriptionCardView()
            }
        } else {
            for (index, store) in storeData.enumerated() where store.storeID == name {
                selectedIndex = index
                print("地圖手勢", index)
                setupDescriptionCardView()
            }
        }
    }
    func cogfigReport(store: Store) -> Int {
        guard let reports = store.queueReport else { return 0 }
        let date = Double(Date().timeIntervalSince1970)
        if !reports.isEmpty {
            guard let report = reports.sorted(by: {$0.createdTime > $1.createdTime}).first else { return 0 }
            if (report.createdTime + 60*60*3) > date {
                return report.queueCount
            } else {
                return 0
            }
        }
        return 0
    }
    func reloadMapView() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
            mapView.addAnnotation(annotation)
        }
    }
    
    
}
extension MappingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        if isSearchResults {
            return filteredStoreData.count
        } else {
            return storeData.count
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StoreCardsCell.self), for: indexPath) as? StoreCardsCell else { return StoreCardsCell() }
        
        cell.delegate = self
        
        var isCollect = false
        if isSearchResults {
            if UserRequestProvider.shared.currentUser != nil {
//                guard let currentUser = currentUser else { return cell }
                let currentUser = currentUser!
                isLogin = true
                let storeRef = storeData.first(where: {$0.storeID == filteredStoreData[indexPath.row].storeID})
                
//                let data = storeRef.collectedUser ?? []
                
                isCollect = storeRef?.collectedUser?.contains(currentUser.userID) ?? false
            } else {
                isLogin = false
            }
            let store = filteredStoreData[indexPath.row]
            
            let commentOfStore = commentData.filter({
                if $0.storeID == store.storeID {
                    return true
                } else {
                    return false
                }
            })
            cell.layoutCardView(dataSource: store, commentData: commentOfStore, isCollect: isCollect, isLogin: isLogin)
            print("搜尋dqCell", filteredStoreData[indexPath.row].name , storeData[indexPath.row].name)
            return cell
        } else {
            if UserRequestProvider.shared.currentUser != nil {
//                guard let currentUser = currentUser else { return cell }
                let currentUser = currentUser!
                let data = storeData[indexPath.row].collectedUser ?? []
                
                isCollect = data.contains(currentUser.userID)
            } else {
                isLogin = false
            }
            
            let store = storeData[indexPath.row]
            
            let commentOfStore = commentData.filter({
                if $0.storeID == store.storeID {
                    return true
                } else {
                    return false
                }
            })
            cell.layoutCardView(dataSource: store, commentData: commentOfStore, isCollect: isCollect, isLogin: isLogin)
            
            print("dqCell" , storeData[indexPath.row].name)
            return cell
        }
    }
}

extension MappingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSeletedCollectionView", indexPath)
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "StorePageViewController") as? StorePageViewController else { return }
        
        if isSearchResults {
            let store = filteredStoreData[indexPath.row]
            
            let commentOfStore = commentData.filter({
                if $0.storeID == store.storeID {
                    return true
                } else {
                    return false
                }
            })
//            storeCardCollectionView.isHidden = true
            controller.currentUser = currentUser
            controller.storeData = store
            controller.commentData = commentOfStore
//            self.addChild(controller)
            navigationController?.pushViewController(controller, animated: true)
            
        } else {
            let store = storeData[indexPath.row]
            
            let commentOfStore = commentData.filter({
                if $0.storeID == store.storeID {
                    return true
                } else {
                    return false
                }
            })
//            storeCardCollectionView.isHidden = retrue
            controller.currentUser = currentUser
            controller.storeData = store
            
            controller.commentData = commentOfStore
//            self.addChild(controller)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let itemSize = CGSize(width: self.storeCardCollectionView.frame.size.width - 2 * 16, height: self.storeCardCollectionView.frame.size.height - 2 * 6)
        let xCenterOffset = targetContentOffset.pointee.x + (itemSize.width / 2.0)
        let indexPath = IndexPath(item: Int(xCenterOffset / (itemSize.width + 16 / 2.0)), section: 0)
        print("滑動", indexPath)
        self.selectedIndex = indexPath.row
        let offset = CGPoint(x: (itemSize.width + 16.0 / 2.0) * CGFloat(indexPath.item), y: 0)
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
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

extension MappingViewController {
    private func addDragFloatBtn() {
        reportButton.frame = CGRect(x: UIScreen.width-70, y: 400, width: 60, height: 60)
        
        reportButton.layer.cornerRadius = 30.0
        self.view .addSubview(reportButton)
        reportButton.setImage( UIImage(named: "broadcast"), for: .normal)
        
        reportButton.backgroundColor = .black.withAlphaComponent(0.4)
        reportButton.tintColor = .white
        reportButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        reportButton.addTarget(self, action: #selector(floatBtnAction(sender:)), for: .touchUpInside)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragAction(gesture:)))
        reportButton .addGestureRecognizer(panGesture)
        
    }
    
    @objc private func dragAction(gesture: UIPanGestureRecognizer) {
        
        let moveState = gesture.state
        switch moveState {
        case .began:
            break
        case .changed:
            let point = gesture.translation(in: self.view)
            self.reportButton.center = CGPoint(x: self.reportButton.center.x + point.x, y: self.reportButton.center.y + point.y)
            break
        case .ended:
            let point = gesture.translation(in: self.view)
            var newPoint = CGPoint(x: self.reportButton.center.x + point.x, y: self.reportButton.center.y + point.y)
            if newPoint.x < self.view.bounds.width / 2.0 {
                newPoint.x = 40.0
            } else {
                newPoint.x = self.view.bounds.width - 40.0
            }
            if newPoint.y <= 40.0 {
                newPoint.y = 40.0
            } else if newPoint.y >= self.view.bounds.height - 40.0 {
                newPoint.y = self.view.bounds.height - 40.0
            }
            UIView.animate(withDuration: 0.5) {
                self.reportButton.center = newPoint
            }
            break
        default:
            break
        }
        gesture.setTranslation(.zero, in: self.view)
    }
    @objc private func floatBtnAction(sender: UIButton) {
        reportButton.isHidden = true
        storeCardCollectionView.isHidden = true
        initReportQueueView()
    }
    private func initReportQueueView() {
        let storeName = storeData[selectedIndex].name
        let reportView: ReportView = UIView.fromNib()
        reportView.delegate = self
        self.view.addSubview(reportView)
        reportView.layoutView(name: storeName)
//        reportView.translatesAutoresizingMaskIntoConstraints = false
        reportView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 400)
//        reportView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        reportView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        reportView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        UIView.animate(withDuration: 0.5) {
            reportView.frame = CGRect(x: 0, y: UIScreen.height-300, width: UIScreen.width, height: 400)
        }
//        reportView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -200).isActive = true
        
    }
    private func pulishQueue(queue: Int) {
        if UserRequestProvider.shared.currentUser != nil {
            if !isSearchResults {
            let storeID = storeData[selectedIndex].storeID
            guard let currentUserID = UserRequestProvider.shared.currentUserID else { return }
            var queue = QueueReport(queueCount: queue)
            QueueReportRequestProvider.shared.publishQueueReport(currentUserID: currentUserID, targetStoreID: storeID, report: &queue) { result in
                switch result {
                case .failure:
                    LKProgressHUD.showFailure(text: "回報失敗")
                case .success:
                    LKProgressHUD.showSuccess(text: "回報成功")
                }
            }
            } else {
                let storeID = filteredStoreData[selectedIndex].storeID
                guard let currentUserID = UserRequestProvider.shared.currentUserID else { return }
                var queue = QueueReport(queueCount: queue)
                QueueReportRequestProvider.shared.publishQueueReport(currentUserID: currentUserID, targetStoreID: storeID, report: &queue) { result in
                    switch result {
                    case .failure:
                        LKProgressHUD.showFailure(text: "回報失敗")
                    case .success:
                        LKProgressHUD.showSuccess(text: "回報成功")
                    }
                }
            }
            
        }
    }
}
extension MappingViewController: ReportViewDelegate {
    func didTapSendButton(_ view: ReportView, queue: Int) {
        if UserRequestProvider.shared.currentUser != nil {
            pulishQueue(queue: queue)
            storeCardCollectionView.isHidden = false
            reportButton.isHidden = false
            view.removeFromSuperview()
        } else {
            view.removeFromSuperview()
            presentWelcomePage()
        }
    }
    func didTapCloseButton(_ view: ReportView) {
        storeCardCollectionView.isHidden = false
        reportButton.isHidden = false
        view.removeFromSuperview()
    }
}
extension MappingViewController: CLLocationManagerDelegate {
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let userLocation: CLLocation = locations[0] as CLLocation
    //        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    //        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    //
    //        mapView.setRegion(mRegion, animated: true)
    //    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
        mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}
extension MappingViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        storeCardCollectionView.isHidden = true
        reportButton.isHidden = true
        setRegion()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // mapView.layoutView(from: storeData)
        //        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setRegion()
        if searchText.isEmpty && isSearchResults {
            isSearchResults = false
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
            storeCardCollectionView.reloadData()
            mapView.layoutView(from: storeData)
        } else {
            filterAnnotation(text: searchText)
        }
    }
    
    private func filterAnnotation(text: String) {
        filteredStoreData = storeData.filter({ store in
            let tag = store.tags.joined()
            let title = store.name
            let address = store.address
            
            let isMatchTags = tag.localizedStandardContains(text)
            let isMatchName = title.localizedStandardContains(text)
            let isMatchAddress = address.localizedStandardContains(text)
            if isMatchTags || isMatchName || isMatchAddress == true {
                return true
            } else {
                return false
            }
        })
//        setupDataForFilteredCell()
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        isSearchResults = true
        storeCardCollectionView.reloadData()
        mapView.layoutView(from: filteredStoreData)
    }
    private func setRegion() {
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.00708, longitude: 121.5598), latitudinalMeters: 20000, longitudinalMeters: 20000), animated: true)
    }
}
extension MappingViewController: StoreCardsCellDelegate {
    func didtapCollectionWhenNotLogin(view: StoreCardsCell) {
        presentWelcomePage()
        
    }
    func presentWelcomePage() {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else { return }
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    func didtapCollectionButton(view: StoreCardsCell, storeID: String) {
        guard let user = currentUser else { return }
        StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "收藏失敗")
                
            }
        }
    }
    
    func didtapUnCollectionButton(view: StoreCardsCell, storeID: String) {
        guard let user = currentUser else { return }
        StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: storeID) { result in
            switch result {
            case .success(let message):
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                LKProgressHUD.showFailure(text: "取消失敗")
                
            }
        }
    }
}

extension MappingViewController: SignInAndOutViewControllerDelegate {
    func didSelectLookAround(_ view: SignInAndOutViewController) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func didSelectGoEditProfile(_ view: SignInAndOutViewController) {
        self.tabBarController?.selectedIndex = 3
    }
    
    
}
