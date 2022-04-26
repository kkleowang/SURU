////
////  SURUDataModel.swift
////  SURU_Leo
////
////  Created by LEO W on 2022/4/13.
////
//
//import Foundation
//
//struct Store: Codable {
//    var storeID: String = ""
//    var name: String
//    var address: String
//    var coordinate: Coordinate
//    var phone: String = ""
//    var tags: [String]
//    var meals: [String]
//    var seat: Int
//    var opentime: Opentime = Opentime(lunchTime: "", dinnertime: "")
//    var menuImage: String
//    var mainImage: String
//    var closeDay: [Int] = []
//}
//struct Coordinate: Codable {
//    var long: Double
//    var lat: Double
//}
//struct Opentime: Codable {
//    var lunchTime: String
//    var dinnertime: String
//}
//
//// MARK: -
//struct StoreQueueReport: Codable {
//    var reportID: String = ""
//    var queueCount: Int
//    var createdTime: Double = 0
//}
//
//// MARK: -
//struct Comment: Codable {
//    var commentID: String = ""
//    var userID: String
//    var storeID: String
//    var meal: String
//    var contentValue: CommentContent
//    var contenText: String
//    var mainImage: String 
//    var createdTime: Double = 0
//    var likedUserList: [String] = []
//    var collectedUserList: [String] = []
//}
//struct CommentContent: Codable {
//    var happiness: Double
//    var noodle: Double
//    var soup: Double
//}
//// MARK: -
//struct Account: Codable {
//    var userID: String = ""
//    var name: String
//    var mainImage: String
//    var provider: String
//    var commentCount: Int = 0
//    var createdTime: Double = 0
//    var likedComment: [LikeComment] = []
//    var collectedComment: [CollectComment] = []
//}
//struct LikeComment: Codable {
//    var likeComment: String
//    var createdTime: Double
//}
//struct CollectComment: Codable {
//    var collectComment: String
//    var createdTime: Double
//}
