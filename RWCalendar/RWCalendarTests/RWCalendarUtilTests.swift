//
//  RWCalendarUtilTests.swift
//  RWCalendarTests
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

@testable import RWCalendar
import XCTest

class RWCalendarUtilTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAllDaysIn() throws {
        func testAllDaysIn(
            year: Int,
            month: Int,
            numberOfDays: Int,
            calendar: Calendar
        ) {
            guard
                let allDays = RWCalendar.Util.allDaysIn(
                    year: year,
                    month: month,
                    calendar: calendar
                )
            else {
                return
            }

            XCTAssertEqual(allDays.count, numberOfDays)

            var expectedDay = 1
            for date in allDays {
                let day = calendar.component(
                    .day,
                    from: date
                )
                let month = calendar.component(
                    .month,
                    from: date
                )
                let year = calendar.component(
                    .year,
                    from: date
                )

                XCTAssertEqual(day, expectedDay)
                XCTAssertEqual(month, month)
                XCTAssertEqual(year, year)
                expectedDay += 1
            }
        }

        let calendar = Calendar(identifier: .gregorian)
        testAllDaysIn(
            year: 2021,
            month: 1,
            numberOfDays: 31,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 2,
            numberOfDays: 28,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 3,
            numberOfDays: 31,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 4,
            numberOfDays: 30,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 5,
            numberOfDays: 31,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 6,
            numberOfDays: 30,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 7,
            numberOfDays: 31,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 8,
            numberOfDays: 31,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 9,
            numberOfDays: 30,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 10,
            numberOfDays: 31,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 11,
            numberOfDays: 30,
            calendar: calendar
        )
        testAllDaysIn(
            year: 2021,
            month: 12,
            numberOfDays: 31,
            calendar: calendar
        )
    }

    func testFirstDayIn() throws {
        let calendar = Calendar(identifier: .gregorian)
        let year = 2021
        for month in 1 ... 12 {
            let dateOpt = RWCalendar.Util.firstDayIn(
                year: year,
                month: month,
                calendar: calendar
            )
            XCTAssertNotNil(dateOpt)

            let date = dateOpt!
            let firstDay = calendar.component(
                .day,
                from: date
            )
            let firstDayMonth = calendar.component(
                .month,
                from: date
            )
            let firstDayYear = calendar.component(
                .year,
                from: date
            )

            XCTAssertEqual(firstDay, 1)
            XCTAssertEqual(firstDayMonth, month)
            XCTAssertEqual(firstDayYear, year)
        }
    }

    func testLastDayIn() throws {
        let calendar = Calendar(identifier: .gregorian)
        let expecteYear = 2021, expectedLastDays = [
            31,
            28,
            31,
            30,
            31,
            30,
            31,
            31,
            30,
            31,
            30,
            31
        ]
        for (expectedMonth, expectedLastDay) in zip(
            1 ... 12,
            expectedLastDays
        ) {
            let dateOpt = RWCalendar.Util.lastDayIn(
                year: expecteYear,
                month: expectedMonth,
                calendar: calendar
            )
            XCTAssertNotNil(dateOpt)

            let date = dateOpt!
            let lastDay = calendar.component(
                .day,
                from: date
            )
            let lastDayMonth = calendar.component(
                .month,
                from: date
            )
            let lastDayYear = calendar.component(
                .year,
                from: date
            )

            XCTAssertEqual(lastDay, expectedLastDay)
            XCTAssertEqual(lastDayMonth, expectedMonth)
            XCTAssertEqual(lastDayYear, expecteYear)
        }
    }

    // swiftlint:disable function_body_length
    func testLastMonthDays() throws {
        let calendar = Calendar(identifier: .gregorian)
        let year = 2021, startOfWeek = Weekday.sunday
        let expectedYears = [
            1: 2020,
            2: 2021,
            3: 2021,
            4: 2021,
            5: 2021,
            6: 2021,
            7: 2021,
            8: 2021,
            9: 2021,
            10: 2021,
            11: 2021,
            12: 2021
        ]
        let expectedMonths = [
            1: 12,
            2: 1,
            3: 2,
            4: 3,
            5: 4,
            6: 5,
            7: 6,
            8: 7,
            9: 8,
            10: 9,
            11: 10,
            12: 11
        ]
        let expectedDays = [
            1: 27 ... 31,
            2: 31 ... 31,
            3: 28 ... 28,
            4: 28 ... 31,
            5: 25 ... 30,
            6: 30 ... 31,
            7: 27 ... 30,
            8: nil,
            9: 29 ... 31,
            10: 26 ... 30,
            11: 31 ... 31,
            12: 28 ... 30
        ]

        for month in 1 ... 12 {
            let lastMonthDaysOpt = RWCalendar.Util
                .lastMonthDays(
                    year: year,
                    month: month,
                    startOfWeek: startOfWeek,
                    calendar: calendar
                )

            XCTAssertNotNil(lastMonthDaysOpt)
            let lastMonthDays = lastMonthDaysOpt!

            XCTAssertNotNil(expectedDays[month] as Any?)
            let expectedRangeOpt = expectedDays[month]!
            if expectedRangeOpt == nil {
                continue
            }

            XCTAssertNotNil(expectedRangeOpt)
            let expectedRange = expectedRangeOpt!

            XCTAssertNotNil(expectedYears[month])
            let expectedYear = expectedYears[month]!

            XCTAssertNotNil(expectedMonths[month])
            let expectedMonth = expectedMonths[month]!

            XCTAssertEqual(
                lastMonthDays.count,
                expectedRange.count
            )

            for (lastMonthDay, expectedLastDay) in zip(
                lastMonthDays,
                expectedRange
            ) {
                check(
                    computedDate: lastMonthDay,
                    expectedYear: expectedYear,
                    expectedMonth: expectedMonth,
                    expectedDay: expectedLastDay,
                    calendar: calendar
                )
            }
        }
    }

    func testNextMonthDays() throws {
        let calendar = Calendar(identifier: .gregorian)
        let year = 2021, startOfWeek = Weekday.sunday
        let expectedYears = [
            1: 2021,
            2: 2021,
            3: 2021,
            4: 2021,
            5: 2021,
            6: 2021,
            7: 2021,
            8: 2021,
            9: 2021,
            10: 2021,
            11: 2021,
            12: 2022
        ]
        let expectedMonths = [
            1: 2,
            2: 3,
            3: 4,
            4: 5,
            5: 6,
            6: 7,
            7: 8,
            8: 9,
            9: 10,
            10: 11,
            11: 12,
            12: 1
        ]
        let expectedDays = [
            1: 1 ... 6,
            2: 1 ... 13,
            3: 1 ... 10,
            4: 1 ... 8,
            5: 1 ... 5,
            6: 1 ... 10,
            7: 1 ... 7,
            8: 1 ... 11,
            9: 1 ... 9,
            10: 1 ... 6,
            11: 1 ... 11,
            12: 1 ... 8
        ]

        for month in 1 ... 12 {
            let nextMonthDaysOpt = RWCalendar.Util
                .nextMonthDays(
                    year: year,
                    month: month,
                    startOfWeek: startOfWeek,
                    additionalDays: true,
                    calendar: calendar
                )

            XCTAssertNotNil(nextMonthDaysOpt)
            let nextMonthDays = nextMonthDaysOpt!

            XCTAssertNotNil(expectedDays[month] as Any?)
            let expectedRange = expectedDays[month]!

            XCTAssertNotNil(expectedYears[month])
            let expectedYear = expectedYears[month]!

            XCTAssertNotNil(expectedMonths[month])
            let expectedMonth = expectedMonths[month]!

            XCTAssertEqual(
                nextMonthDays.count,
                expectedRange.count
            )

            for (nextMonthDay, expectedNextDay) in zip(
                nextMonthDays,
                expectedRange
            ) {
                check(
                    computedDate: nextMonthDay,
                    expectedYear: expectedYear,
                    expectedMonth: expectedMonth,
                    expectedDay: expectedNextDay,
                    calendar: calendar
                )
            }
        }
    }

    func testStartOfDay() throws {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let expectedDate = calendar.date(from: components)
        XCTAssertNotNil(expectedDate)

        guard let expectedDate = expectedDate else {
            return
        }

        let targetDate = RWCalendar.Util.startOfDay(Date(), calendar: calendar)
        XCTAssertNotNil(targetDate)
        guard let targetDate = targetDate else {
            return
        }

        XCTAssertEqual(expectedDate, targetDate)
    }

    func testEndOfDay() throws {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let date = calendar.date(from: components)
        XCTAssertNotNil(date)

        guard let date = date else {
            return
        }
        let nextDate = calendar.date(byAdding: .day, value: 1, to: date)
        XCTAssertNotNil(nextDate)

        guard let nextDate = nextDate else {
            return
        }
        let expectedDate = calendar.date(byAdding: .second, value: -1, to: nextDate)
        XCTAssertNotNil(expectedDate)

        guard let expectedDate = expectedDate else {
            return
        }

        let targetDate = RWCalendar.Util.endOfDay(Date(), calendar: calendar)
        XCTAssertNotNil(targetDate)
        guard let targetDate = targetDate else {
            return
        }

        XCTAssertEqual(expectedDate, targetDate)
    }

    // MARK: - Utility

    func check(
        computedDate: Date,
        expectedYear: Int,
        expectedMonth: Int,
        expectedDay: Int,
        calendar: Calendar
    ) {
        XCTAssertEqual(
            calendar.component(.day, from: computedDate),
            expectedDay
        )
        XCTAssertEqual(
            calendar.component(.month, from: computedDate),
            expectedMonth
        )
        XCTAssertEqual(
            calendar.component(.year, from: computedDate),
            expectedYear
        )
    }
}
