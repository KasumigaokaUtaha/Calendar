//
//  RWCalendarDateDataTests.swift
//  RWCalendarTests
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

@testable import RWCalendar
import XCTest

class RWCalendarDateDataTests: XCTestCase {
    let weekdays: [RWCalendar.Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeekdayValue() throws {
        let expectedWeekdayValues = [1, 2, 3, 4, 5, 6, 7]

        for (weekday, expectedValue) in zip(weekdays, expectedWeekdayValues) {
            XCTAssertEqual(weekday.value(), expectedValue)
        }
    }

    func testWeekdayValueBase() throws {
        let weekdayBases: [RWCalendar.Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        let expectedWeekdayValues: [RWCalendar.Weekday: [Int]] = [
            .monday: [1, 2, 3, 4, 5, 6, 7],
            .tuesday: [7, 1, 2, 3, 4, 5, 6],
            .wednesday: [6, 7, 1, 2, 3, 4, 5],
            .thursday: [5, 6, 7, 1, 2, 3, 4],
            .friday: [4, 5, 6, 7, 1, 2, 3],
            .saturday: [3, 4, 5, 6, 7, 1, 2],
            .sunday: [2, 3, 4, 5, 6, 7, 1]
        ]

        for weekdayBase in weekdayBases {
            XCTAssertNotNil(expectedWeekdayValues[weekdayBase])
            let expectedWeekdayValue = expectedWeekdayValues[weekdayBase]!

            for (weekday, expectedValue) in zip(weekdays, expectedWeekdayValue) {
                XCTAssertEqual(weekday.value(base: weekdayBase), expectedValue)
            }
        }
    }
}
