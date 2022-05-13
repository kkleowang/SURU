//
//  CommentDataModel.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Foundation

struct Comment: Codable {
    var commentID: String = ""
    var userID: String
    var storeID: String
    var meal: String
    var contentValue: CommentContent
    var contenText: String
    var mainImage: String
    var createdTime: Double = 0
    var likedUserList: [String] = []
    var collectedUserList: [String] = []
    var userComment: [Message]?
    var sideDishes: String?
}
struct CommentContent: Codable {
    var happiness: Double
    var noodle: Double
    var soup: Double
}
struct Message: Codable {
    var userID: String
    var message: String
    var createdTime: Double = 0
}
