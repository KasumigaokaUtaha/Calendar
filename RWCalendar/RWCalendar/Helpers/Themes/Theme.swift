//
//  Theme.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2021/12/24.
//

import UIKit

/// Define the base theme protocol
protocol Theme {
    var backgroundColor: UIColor { get } // background color
    var foregroundColor: UIColor { get } // text color
    var primaryColor: UIColor { get } // main color
    var secondaryColor: UIColor { get } // backup color
    var themeName: String { get } // theme name
}
