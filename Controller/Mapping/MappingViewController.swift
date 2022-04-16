//
//  MappingViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit
import MapKit

class MappingViewController: UIViewController {

    var storeData: [Store] = []
    var smapView = MapView()
    func fetchData() {
        FirebaseRequestProvider.shared.fetchStores { [weak self] result in
            switch result {
            case .success(let data):
                self?.storeData = data
                print("Get all store data from firebase in Mapping page")
            case .failure(let error):
                print("Mapping page error with code: \(error)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "地圖頁"
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "地圖頁"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
