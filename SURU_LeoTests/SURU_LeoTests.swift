//
//  SURU_LeoTests.swift
//  SURU_LeoTests
//
//  Created by LEO W on 2022/5/20.
//

import XCTest
// swiftlint:disable type_name
// swiftlint:disable implicitly_unwrapped_optional
@testable import SURU_Leo
class SURU_LeoTests: XCTestCase {
    var sut: BadgeTierManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = BadgeTierManager()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testjudgeBadgeLevel() {
        // given
        let level = [10, 20, 30, 40, 50]
        sut.tierCondition = level
        
        // when then
        XCTAssertEqual(sut.inRange(level[0] - 5), [0, 0, 0, 0, 0], "Level 0 result Not right")
        XCTAssertEqual(sut.inRange(level[0]), [1, 0, 0, 0, 0], "Level 1 result Not right")
        XCTAssertEqual(sut.inRange(level[1]), [1, 1, 0, 0, 0], "Level 2 result Not right")
        XCTAssertEqual(sut.inRange(level[2]), [1, 1, 1, 0, 0], "Level 3 result Not right")
        XCTAssertEqual(sut.inRange(level[3]), [1, 1, 1, 1, 0], "Level 4 result Not right")
        XCTAssertEqual(sut.inRange(level[4]), [1, 1, 1, 1, 1], "Level 5 result Not right")
        XCTAssertEqual(sut.inRange(level[4] + 5), [1, 1, 1, 1, 1], "Level 5 result Not right")
    }
    
    func testjudgeBadgeResultCount() {
        var conditionArray: [Int] = []
        for i in 0...20 {
            // given
            conditionArray = Array(repeating: i * 5, count: i)
            sut.tierCondition = conditionArray
            // when than
            XCTAssertEqual(conditionArray.count, sut.inRange(10).count, "ResultArray's count not fit")
        }
    }
}
