//
//  TestingCenterViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/13.
//

import UIKit

class TestingCenterViewController: UIViewController {
    let url = "https://firebasestorage.googleapis.com/v0/b/suru-4c219.appspot.com/o/SURU_App_Assets%2F%E6%88%AA%E5%9C%96%202022-04-08%20%E4%B8%8B%E5%8D%881.28.50.png?alt=media&token=7615a77c-3dd3-4455-bb23-ac261a71abc7B"
    var account = Account(name: "測試帳號2", mainImage: "url", provider: "測試生成22")
    var store1 = Store(
        name: "北一家",
        coordinate: Coordinate(long: 25.075, lat: 121.577),
        tags: ["煽系", "鹽味", "醬油", "豚骨"],
        meals: ["煽系拉麵", "鹽味拉麵", "醬油拉麵", "豚骨拉麵"],
        seat: 20,
        menuImage: "沒有照片",
        mainImage: "沒有拉",
        closeDay: 2)

    let userID = "VjsgHk3XKH6a0azsv3c5"
    let firebaseRequestProvider = FirebaseRequestProvider.shared
    
    @IBAction func readAllComment() {
        
    }
    @IBAction func readAllStore() {
        
    }
    @IBAction func readStoreByID() {
        
    }
    @IBAction func writeCommentByStoreID() {
        
    }
    @IBAction func writeReportByStoreID() {
        
    }
    @IBAction func writeAccount() {
        firebaseRequestProvider.publishRegistedAccount(account: &account) { [weak self] result in
            switch result {
            case .success(let string):
                print(string)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func adminWriteStore() {
        firebaseRequestProvider.adminPublishNewStore(store: &store1) { [weak self] result in
            switch result {
            case .success(let string):
                print(string)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
