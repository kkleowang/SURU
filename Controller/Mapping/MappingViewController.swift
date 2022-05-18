//
//  MappingViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit
import MapKit

class MappingViewController: UIViewController {
    private var commentData: [Comment] = []
    private var currentUser: Account?
    private var reportButton = UIButton()
    private let mapView = MapView()
    private var searchBar = UISearchBar()
    
    private var isSearchResults = false
    
    private var storeData: [Store] = [] {
        didSet {
            storeData = storeData.sorted {
                $0.coordinate.long < $1.coordinate.long
            }
        }
    }
    private var filteredStoreData: [Store] = []
    
    private var storeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var selectedIndex = 0
    
    func setRegionToAnnotation() {
        var store: Store?
        if isSearchResults {
            store = filteredStoreData[selectedIndex]
        } else {
            store = storeData[selectedIndex]
        }
        if let store = store {
            let selectedLocation = CLLocationCoordinate2D(latitude: store.coordinate.lat - 0.002, longitude: store.coordinate.long)
            mapView.setRegion(MKCoordinateRegion(center: selectedLocation, latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
        }
    }
    func scrollToAnnotation() {
        storeCollectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeCurrentAccount()
        observeCommentData()
        self.observeLoginStatus()
        StoreRequestProvider.shared.listenStore {
            self.updataStore()
        }
        self.view.stickSubView(mapView)
        storeCollectionView.isHidden = true
        setupReportButton()
        fetchData {
            LKProgressHUD.showSuccess(text: "下載資料成功")
            
            self.setupSearchBar()
            self.setupMapView()
            self.setupHiddenCollectionView()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        storeCollectionView.reloadData()
        reloadMapView()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.09108, longitude: 121.5598), latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: true)
        mapView.layoutView(from: storeData)
    }
    private func setupHiddenCollectionView() {
        if let flowLayout = storeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        storeCollectionView.register(UINib(nibName: StoreCardsCell.identifier, bundle: nil), forCellWithReuseIdentifier: StoreCardsCell.identifier)
        storeCollectionView.dataSource = self
        storeCollectionView.delegate = self
        self.view.addSubview(storeCollectionView)
        storeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        storeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        storeCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        storeCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        storeCollectionView.heightAnchor.constraint(equalTo: storeCollectionView.widthAnchor, multiplier: 230 / 390).isActive = true
        storeCollectionView.backgroundColor = .clear
    }
    private func configStoreView() {
        if storeCollectionView.isHidden {
            storeCollectionView.isHidden = false
        }
        if reportButton.isHidden {
            reportButton.isHidden = false
        }
    }
    private func showLoginPage() {
        guard let tabbarController = tabBarController as? TabBarViewController else { return }
        tabbarController.presentWelcomePage()
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
                self.storeCollectionView.reloadData()
                self.reloadMapView()
            case .failure(let error) :
                print("下載商店資料失敗", error)
            }
        }
    }
    private func observeCurrentAccount() {
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
    private func                 observeCommentData() {
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
    private func observeLoginStatus() {
        UserRequestProvider.shared.listenFirebaseLoginSendAccount { result in
            switch result {
            case .success(let data) :
                self.currentUser = data
            case .failure :
                self.currentUser = nil
            }
        }
    }
    private func fetchData(competion: @escaping () -> Void) {
        let group = DispatchGroup()
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
    func setupSearchBar() {
        searchBar.tintColor = .B1
        searchBar.searchTextField.autocorrectionType = .no
        searchBar.returnKeyType = .search
        searchBar.placeholder = " Search..."
        searchBar.isTranslucent = false
        searchBar.enablesReturnKeyAutomatically = false
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) {
                backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                backgroundView?.subviews.forEach { $0.removeFromSuperview() }
            }
            backgroundView?.layer.cornerRadius = 10.5
            backgroundView?.layer.masksToBounds = true
        }
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
}

extension MappingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let viewSize = 50.0
        let iconView: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: viewSize, height: viewSize))
            imageView.layer.cornerRadius = viewSize / 2
            imageView.layer.borderWidth = 2.0
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        if annotation is MKUserLocation { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.frame = CGRect(x: 0, y: 0, width: viewSize, height: viewSize)
        
        if let store = storeData.first(where: { $0.name == annotation.title }) {
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
            iconView.loadImage(store.mainImage, placeHolder: UIImage(named: "mainImage") )
            annotationView?.subviews.forEach { $0.removeFromSuperview() }
            annotationView?.addSubview(iconView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAnnotationView(sender:)))
            tap.name = store.storeID
            annotationView?.addGestureRecognizer(tap)
        }
        return annotationView
    }
    @objc func didTapAnnotationView(sender: UITapGestureRecognizer) {
        searchBar.endEditing(true)
        guard let name = sender.name else { return }
        var index: Int?
        if isSearchResults {
            index = filteredStoreData.firstIndex { $0.storeID == name }
        } else {
            index = storeData.firstIndex { $0.storeID == name }
        }
        if let index = index {
            selectedIndex = index
            setRegionToAnnotation()
            scrollToAnnotation()
            configStoreView()
        }
    }
    
    func cogfigReport(store: Store) -> Int {
        guard let reports = store.queueReport else { return 0 }
        let date = Double(Date().timeIntervalSince1970)
        if !reports.isEmpty {
            guard let report = reports.sorted(by: { $0.createdTime > $1.createdTime }).first else { return 0 }
            if (report.createdTime + 60 * 60) > date {
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
        if isSearchResults {
            return filteredStoreData.count
        } else {
            return storeData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCardsCell.identifier, for: indexPath) as? StoreCardsCell else { return StoreCardsCell() }
        cell.delegate = self
        
        var isCollect = false
        var isLogin = false
        var store: Store?
        if isSearchResults {
            store = filteredStoreData[indexPath.row]
        } else {
            store = storeData[indexPath.row]
        }
        guard let store = store else { return cell }
        if UserRequestProvider.shared.currentUser != nil {
            guard let currentUser = currentUser else { return cell }
            isCollect = store.collectedUser?.contains(currentUser.userID) ?? false
            isLogin = true
        }
        let comments = commentData.filter {
            if $0.storeID == store.storeID {
                return true
            } else {
                return false
            }
        }
        cell.layoutCell(dataSource: store, commentData: comments, isCollect: isCollect, isLogin: isLogin)
        return cell
    }
}

extension MappingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentUser = currentUser else {
            showLoginPage()
            return
        }
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "StorePageViewController") as? StorePageViewController else { return }
        var store: Store?
        if isSearchResults {
            store = filteredStoreData[indexPath.row]
        } else {
            store = storeData[indexPath.row]
        }
        if let store = store {
            let comments = commentData.filter {
                if $0.storeID == store.storeID {
                    return true
                } else {
                    return false
                }
            }
            controller.currentUser = currentUser
            controller.storeData = store
            controller.commentData = comments
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemSize = CGSize(width: storeCollectionView.frame.size.width - 2 * 16, height: storeCollectionView.frame.size.height - 2 * 6)
        let xCenterOffset = targetContentOffset.pointee.x + (itemSize.width / 2.0)
        let indexPath = IndexPath(item: Int(xCenterOffset / (itemSize.width + 16 / 2.0)), section: 0)
        let offset = CGPoint(x: (itemSize.width + 16.0 / 2.0) * CGFloat(indexPath.item), y: 0)
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        targetContentOffset.pointee = offset
        selectedIndex = indexPath.row
        setRegionToAnnotation()
    }
}
extension MappingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        let cellSize = CGSize(width: size.width - 2 * 16.0, height: size.height - 2 * 6.0)
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
    private func setupReportButton() {
        reportButton.isHidden = true
        reportButton.frame = CGRect(x: UIScreen.width - 70, y: 400, width: 60, height: 60)
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
        default:
            break
        }
        gesture.setTranslation(.zero, in: self.view)
    }
    @objc private func floatBtnAction(sender: UIButton) {
        reportButton.isHidden = true
        storeCollectionView.isHidden = true
        initReportQueueView()
    }
    private func initReportQueueView() {
        let storeName = storeData[selectedIndex].name
        let reportView: ReportView = UIView.fromNib()
        reportView.delegate = self
        self.view.addSubview(reportView)
        reportView.layoutView(name: storeName)
        reportView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 400)
        UIView.animate(withDuration: 0.5) {
            reportView.frame = CGRect(x: 0, y: UIScreen.height - 300, width: UIScreen.width, height: 400)
        }
    }
    private func pulishQueue(queue: Int) {
        guard let currentUserID = UserRequestProvider.shared.currentUserID else { return }
        var storeID = ""
        if isSearchResults {
            storeID = filteredStoreData[selectedIndex].storeID
        } else {
            storeID = storeData[selectedIndex].storeID
        }
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
extension MappingViewController: ReportViewDelegate {
    func didTapSendButton(_ view: ReportView, queue: Int) {
        if UserRequestProvider.shared.currentUser != nil {
            pulishQueue(queue: queue)
            storeCollectionView.isHidden = false
            reportButton.isHidden = false
            view.removeFromSuperview()
        } else {
            showLoginPage()
        }
    }
    func didTapCloseButton(_ view: ReportView) {
        storeCollectionView.isHidden = false
        reportButton.isHidden = false
        view.removeFromSuperview()
    }
}
extension MappingViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        setOriginRegion()
        storeCollectionView.isHidden = true
        reportButton.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        configStore(text: searchText)
    }
    private func configStore(text: String) {
        setOriginRegion()
        if text.isEmpty && isSearchResults {
            isSearchResults = false
            filteredStoreData = storeData
        } else {
            isSearchResults = true
            filteredStoreData = storeData.filter {
                let tag = $0.tags.joined()
                let title = $0.name
                let address = $0.address
                
                let isMatchTags = tag.localizedStandardContains(text)
                let isMatchName = title.localizedStandardContains(text)
                let isMatchAddress = address.localizedStandardContains(text)
                if isMatchTags || isMatchName || isMatchAddress == true {
                    return true
                } else {
                    return false
                }
            }
        }
        storeCollectionView.reloadData()
        mapView.layoutView(from: filteredStoreData)
    }
    
    private func setOriginRegion() {
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.00708, longitude: 121.5598), latitudinalMeters: 20000, longitudinalMeters: 20000), animated: true)
    }
}
extension MappingViewController: StoreCardsCellDelegate {
    func didtapCollectionWhenNotLogin(view: StoreCardsCell) {
        showLoginPage()
    }
    func didtapCollectionButton(view: StoreCardsCell, storeID: String) {
        if let user = currentUser {
            StoreRequestProvider.shared.collectStore(currentUserID: user.userID, tagertStoreID: storeID) { result in
                switch result {
                case .success(let message):
                    LKProgressHUD.showSuccess(text: message)
                case .failure:
                    LKProgressHUD.showFailure(text: "收藏失敗")
                }
            }
        } else {
            showLoginPage()
        }
    }
    
    func didtapUnCollectionButton(view: StoreCardsCell, storeID: String) {
        if let user = currentUser {
            StoreRequestProvider.shared.unCollectStore(currentUserID: user.userID, tagertStoreID: storeID) { result in
                switch result {
                case .success(let message):
                    LKProgressHUD.showSuccess(text: message)
                case .failure:
                    LKProgressHUD.showFailure(text: "取消失敗")
                }
            }
        } else {
            showLoginPage()
        }
    }
}
