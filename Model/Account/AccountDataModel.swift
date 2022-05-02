//
//  AccountDataModel.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Foundation

struct Account: Codable {
    var userID: String
    var name: String = ""
    var mainImage: String = ""
    var provider: String
    var commentCount: Int = 0
    var createdTime: Double = 0
    var likedComment: [LikeComment] = []
    var collectedStore: [String] = []
    var follower: [String] = []
    var followedUser: [String] = []
}
struct LikeComment: Codable {
    var likeComment: String
    var createdTime: Double
}
struct CollectComment: Codable {
    var collectComment: String
    var createdTime: Double
}
