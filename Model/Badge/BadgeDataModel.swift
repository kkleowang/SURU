//
//  BadgeDataModel.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/6.
//

import Foundation
import UIKit



let badgeFile = [
    ["login1", "login2", "login3", "login4", "login5"],
    ["comment1", "comment2", "comment3", "comment4", "comment5"],
    ["report1", "report2", "report3", "report4", "report5"],
    ["like1", "like2", "like3", "like4", "like5"],
    ["follower1", "follower2", "follower3", "follower4", "follower5"],
   
]
enum BadgePicture: String {
    case loginLevel1 = "login1"
    case loginLevel2 = "login2"
    case loginLevel3 = "login3"
    case loginLevel4 = "login4"
    case loginLevel5 = "login5"
    
    case likeLevel1 = "like1"
    case likeLevel2 = "like2"
    case likeLevel3 = "like3"
    case likeLevel4 = "like4"
    case likeLevel5 = "like5"
    
    case commentLevel1 = "comment1"
    case commentLevel2 = "comment2"
    case commentLevel3 = "comment3"
    case commentLevel4 = "comment4"
    case commentLevel5 = "comment5"
    
    case followerLevel1 = "follower1"
    case followerLevel2 = "follower2"
    case followerLevel3 = "follower3"
    case followerLevel4 = "follower4"
    case followerLevel5 = "follower5"
    
    case reportLevel1 = "report1"
    case reportLevel2 = "report2"
    case reportLevel3 = "report3"
    case reportLevel4 = "report4"
    case reportLevel5 = "report5"
}
