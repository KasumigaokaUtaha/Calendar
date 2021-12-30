//
//  RWCalendarTests.swift
//  RWCalendarTests
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

@testable import RWCalendar
import XCTest

class RWCalendarTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testUtil() throws {
        let year = 2021, month = 12, calendar = Calendar(identifier: .gregorian)
        guard let allDays = RWCalendar.Util.allDaysIn(year: year, month: month, calendar: calendar) else {
            return
        }

        XCTAssertEqual(allDays.count, 31)

        var expectedDay = 1, expectedWeekdayNum = 4
        for (day, weekday) in allDays {
            XCTAssertEqual(day, expectedDay)
            let expectedWeekdayOpt = RWCalendar.Weekday(expectedWeekdayNum, calendar: calendar)
            XCTAssertNotNil(expectedWeekdayOpt)
            let expectedWeekday = expectedWeekdayOpt!
            XCTAssertEqual(weekday, expectedWeekday)

            expectedDay += 1
            expectedWeekdayNum += 1
            if expectedWeekdayNum == 8 {
                expectedWeekdayNum = 1
            }
        }
    }

    func testFirstDayIn() throws {
        let year = 2021, calendar = Calendar(identifier: .gregorian)
        for month in 1 ... 12 {
            let dateOpt = RWCalendar.Util.firstDayIn(year: year, month: month, calendar: calendar)
            XCTAssertNotNil(dateOpt)

            let date = dateOpt!
            let firstDayYear = calendar.component(.year, from: date)
            let firstDayMonth = calendar.component(.month, from: date)
            let firstDay = calendar.component(.day, from: date)

            XCTAssertEqual(firstDayYear, 2021)
            XCTAssertEqual(firstDayMonth, month)
            XCTAssertEqual(firstDay, 1)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
