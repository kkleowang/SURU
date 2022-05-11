//
//  AccountDataModel.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Foundation

struct Account: Codable {
    var userID: String
    var name: String = "新訪客"
    var mainImage: String = "https://firebasestorage.googleapis.com/v0/b/suru-4c219.appspot.com/o/SURU_App_Assets%2Flogo-02.png?alt=media&token=62595822-6b39-4522-a92b-f7f260145c49"
    var provider: String
    var commentCount: Int = 0
    var createdTime: Double = 0
    var likedComment: [String] = []
    var collectedStore: [String] = []
    var follower: [String] = []
    var followedUser: [String] = []
    var sendReportCount: Int? = 0
    var myCommentLike: Int? = 0
    var blockUserList: [String]? = []
    var bio: String? = "他還沒新增個人資料"
    var websideLink: String?
    var loginHistory: [String]? = []
    var badgeStatus: String?
}
