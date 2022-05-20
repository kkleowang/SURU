//
//  BadgeTierManager.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/19.
//

import Foundation


struct BadgeTierManager {
    var tierCondition: [Int]
    
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
