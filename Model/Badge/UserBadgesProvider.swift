//
//  UserBadgesProvider.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/6.
//

import Foundation

class UserBadgesProvider {
    
    static let shared = UserBadgesProvider()
    
    func manageAchievement(user: Account, completion: @escaping (Result<String, Error>) -> Void) {
        let followerCount = user.follower.count
        let loginCount = user.loginCount
        let publishCommentCount = user.commentCount
        let publishReportCount = user.sendReportCount
        let likeCount = user.myCommentLike
        switch loginCount {
        case <1 :
            print("123")
        }
        
    }
}
///enum BadgeValue: Int {
//    case loginLevel1 = 1
//    case loginLevel2 = 3
//    case loginLevel3 = 7
//    case loginLevel4 = 15
//    case loginLevel5 = 30
//
//    case likeLevel1 = 10
//    case likeLevel2 = 30
//    case likeLevel3 = 50
//    case likeLevel4 = 100
//    case likeLevel5 = 200
//
//    case commentLevel1 = 1
//    case commentLevel2 = 5
//    case commentLevel3 = 10
//    case commentLevel4 = 20
//    case commentLevel5 = 30
//
//    case followerLevel1 = 5
//    case followerLevel2 = 10
//    case followerLevel3 = 20
//    case followerLevel4 = 30
//    case followerLevel5 = 50
//
//    case reportLevel1 = 1
//    case reportLevel2 = 5
//    case reportLevel3 = 10
//    case reportLevel4 = 15
//    case reportLevel5 = 20
//}
