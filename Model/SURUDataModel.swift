//
//  SURUDataModel.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/13.
//

import Foundation

struct Store {
    let storeID: String
    let name: String
    let coordinate: Coordinate
    let tags: [String]
    let meals: [String]
    let seat: Int
    let opentime: Opentime
    let menuImage: String
    let mainImage: String
    let closeDay: Int
}
struct Coordinate {
    let long: Double
    let lat: Double
}
struct Opentime {
    let lunchTime: String
    let dinnertime: String
}

// MARK: -
struct StoreQueueReport {
    let reportID: String
    let queueCount: Int
    let createTime: Double
}

// MARK: -
struct Comment {
    let commentID: String
    let userID: String
    let storeID: String
    let meal: String
    let content: CommentContent
    let detailText: String
    let detailImage: String
    let createTime: Double
    let likedUserList: [String]
    let collectedUserList: [String]
}
struct CommentContent {
    let happiness: Int
    let noodle: Int
    let soup: Int
}
// MARK: -
struct Account {
    let userID: String
    let name: String
    let mainImage: String
    let provider: String
    let commentCount: Int
    let createTime: Double
    let likedComment: [LikeComment]
    let collectedComment: [CollectComment]
}
struct LikeComment {
    let likeComment: String
    let createTime: Double
}
struct CollectComment {
    let collectComment: String
    let createTime: Double
}
