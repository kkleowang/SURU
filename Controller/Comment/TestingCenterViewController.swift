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
        address: "114台北市內湖區江南街71巷16弄38號",
        coordinate: Coordinate(long: 121.5754608, lat: 25.0755753),
        phone: "",
        tags: ["煽系", "鹽味", "醬油", "豚骨", "味噌"],
        meals: ["味噌拉麵", "激辛拉麵", "醬油拉麵", "鹽味拉麵", "鹽味拉麵", "魚介味噌拉麵"],
        seat: 20,
        opentime: Opentime(lunchTime: "", dinnertime: "17:30–21:00"),
        menuImage: "沒有照片",
        mainImage: "https://firebasestorage.googleapis.com/v0/b/suru-4c219.appspot.com/o/SURU_App_Assets%2FStoreMainImage%2F%E5%8C%97%E4%B8%80%E5%AE%B6.jpeg?alt=media&token=2420a1df-53c2-4a4a-81c3-8ea46b1a8159",
        closeDay: [7,1])
    var store2 = Store(
        name: "麵屋壹の穴",
        address: "106台北市大安區延吉街137巷22號",
        coordinate: Coordinate(long: 121.5547729, lat: 25.0418912),
        phone: "02-27114319",
        tags: ["魚介", "煮干", "豚骨", "二郎"],
        meals: ["魚介豚骨拉麵", "魚介豚骨麻辣拉麵", "煮干拉麵", "日式乾擔擔面", "壹の雞湯拉麵", "壹の二郎拉麵", "痛風二郎拉麵"],
        seat: 15,
        opentime: Opentime(lunchTime: "11:30–15:00", dinnertime: "17:30–21:00"),
        menuImage: "沒有照片",
        mainImage: "https://firebasestorage.googleapis.com/v0/b/suru-4c219.appspot.com/o/SURU_App_Assets%2FStoreMainImage%2FICHI.jpeg?alt=media&token=c6344000-88f7-4279-a668-00d55969b2b1",
        closeDay: [1])
    var store3 = Store(
        name: "鬼金棒",
        address: "10491台北市中山區中山北路一段94號",
        coordinate: Coordinate(long: 121.5209982, lat: 25.0493906),
        phone: "",
        tags: ["味噌", "沾麵", "豚骨"],
        meals: ["辣麻味噌沾麵", "辣麻味噌拉麵", "特製辣麻味噌拉麵", "豚骨拉麵"],
        seat: 14,
        opentime: Opentime(lunchTime: "12:00–14:00", dinnertime: "17:00–20:30"),
        menuImage: "沒有照片",
        mainImage: "https://firebasestorage.googleapis.com/v0/b/suru-4c219.appspot.com/o/SURU_App_Assets%2FStoreMainImage%2F%E9%AC%BC%E9%87%91%E6%A3%92.jpeg?alt=media&token=ba720124-44ec-4f1c-a915-a7aea6a87116",
        closeDay: [])
    var store6 = Store(
        name: "隱家拉麵 士林店",
        address: "111台北市士林區中山北路五段505巷1號",
        coordinate: Coordinate(long: 121.4918889, lat: 25.0590224),
        phone: "02-28881026",
        tags: ["沾麵", "豚骨", "醬油", "蝦", "魚介"],
        meals: ["豚骨醬油拉麵", "辛豚骨拉麵", "濃厚海老沾麵", "黃金雞湯拉麵", "濃厚擔擔麵", "真鯛魚清湯拉麵", "真鯛魚白湯拉麵"],
        seat: 10,
        opentime: Opentime(lunchTime: "11:30–14:00", dinnertime: "16:30–22:00"),
        menuImage: "沒有照片",
        mainImage: "https://firebasestorage.googleapis.com/v0/b/suru-4c219.appspot.com/o/SURU_App_Assets%2FStoreMainImage%2F%E9%9A%B1%E5%AE%B6.jpeg?alt=media&token=7228266b-06e5-4482-be7a-b1cd1971aeca",
        closeDay: [])
    var store7 = Store(
        name: "麵屋雞金",
        address: "100台北市中正區新生南路一段6號1樓",
        coordinate: Coordinate(long: 121.5305216, lat: 25.0440407),
        phone: "02-033933318",
        tags: ["雞白湯", "魚介"],
        meals: ["元祖雞白湯拉麵", "辛味噌雞白湯拉麵", "魚介醬油"],
        seat: 12,
        opentime: Opentime(lunchTime: "11:30–15:00", dinnertime: "17:00–21:00"),
        menuImage: "沒有照片",
        mainImage: "https://firebasestorage.googleapis.com/v0/b/suru-4c219.appspot.com/o/SURU_App_Assets%2FStoreMainImage%2F%E9%9B%9E%E9%87%91.jpeg?alt=media&token=0b30a4fd-0ceb-4fde-919c-3d39166624ac",
        closeDay: [])
    var store5 = Store(
        name: "拉麵公子",
        address: "104台北市中山區八德路二段279號",
        coordinate: Coordinate(long: 121.5395003, lat: 25.0471174),
        phone: "",
        tags: ["雞湯", "醬油"],
        meals: ["醬油雞湯拉麵", "鹽味雞湯拉麵"],
        seat: 20,
        opentime: Opentime(lunchTime: "11:30–13:30", dinnertime: "17:30–20:30"),
        menuImage: "沒有照片",
        mainImage: "https://firebasestorage.googleapis.com/v0/b/suru-4c219.appspot.com/o/SURU_App_Assets%2FStoreMainImage%2F%E6%8B%89%E9%BA%B5%E5%85%AC%E5%AD%90.jpeg?alt=media&token=16193c3c-1770-4f08-879e-b75ffa3a146c",
        closeDay: [])
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
        let stores: [Store] = [store1, store2, store3, store6, store7, store5]
        
        firebaseRequestProvider.adminPublishNewStore(store: &store1) { [weak self] result in
            switch result {
            case .success(let string):
                print(string)
                
            case .failure(let error):
                print(error)
            }
        }
        firebaseRequestProvider.adminPublishNewStore(store: &store2) { [weak self] result in
            switch result {
            case .success(let string):
                print(string)
                
            case .failure(let error):
                print(error)
            }
        }
        firebaseRequestProvider.adminPublishNewStore(store: &store3) { [weak self] result in
            switch result {
            case .success(let string):
                print(string)
                
            case .failure(let error):
                print(error)
            }
        }
        firebaseRequestProvider.adminPublishNewStore(store: &store5) { [weak self] result in
            switch result {
            case .success(let string):
                print(string)
                
            case .failure(let error):
                print(error)
            }
        }
        firebaseRequestProvider.adminPublishNewStore(store: &store6) { [weak self] result in
            switch result {
            case .success(let string):
                print(string)
                
            case .failure(let error):
                print(error)
            }
        }
        firebaseRequestProvider.adminPublishNewStore(store: &store7) { [weak self] result in
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
