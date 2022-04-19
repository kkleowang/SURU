//
//  StoreDataModel.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Foundation

struct Store: Codable {
    var storeID: String = ""
    var name: String
    var address: String
    var coordinate: Coordinate
    var phone: String = ""
    var tags: [String]
    var meals: [String]
    var seat: Int
    var opentime: Opentime = Opentime(lunchTime: "", dinnertime: "")
    var menuImage: String
    var mainImage: String
    var closeDay: [Int] = []
}
struct Coordinate: Codable {
    var long: Double
    var lat: Double
}
struct Opentime: Codable {
    var lunchTime: String
    var dinnertime: String
}
