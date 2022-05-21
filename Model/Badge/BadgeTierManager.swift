//
//  BadgeTierManager.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/19.
//

//import Foundation

// swiftlint: disable implicitly_unwrapped_optional
/*
 This Model convert a sequence Of archivment condition, and judge the level of user.
 
 Input example:
 
        let loginManager = BadgeTierManager()
        BadgeTierManager.tierCondition = [5, 10, 15, 20, 30]  // level 1~5
 
        let loginCount = user.loginCount
        BadgeTierManager.inRange(loginCount)
                                                // if loginCount = 15 outPut:[1,1,1,0,0]
 Use case :
        let badgeStatus = BadgeTierManager.inRange(loginCount)
        if badgeStatus[indexPath.row] == 1 {
            enable Button
        } else {
            disable Button , set gray background.
        }
 */
struct BadgeTierManager {
    var tierCondition: [Int]!
    
    func inRange(_ data: Int) -> [Int] {
        let tier: [Int] = Array(tierCondition.reversed())
        guard data != 0 else { return initBadge(0) }
        for i in 0..<tier.count {
            guard data >= tier[i] else { continue }
            return  initBadge(tier.count - i)
        }
        return initBadge(0)
    }
    
    private func initBadge(_ badgeTier: Int) -> [Int] {
        var array: [Int] = Array(repeating: 0, count: tierCondition.count)
        (0..<badgeTier).forEach { array[$0] = 1 }
        return array
    }
}
