//
//  ThemeDefinitions.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2021/12/24.
//

import UIKit

// Define the structure for different themes

struct Theme0: Theme {
    var backgroundColor: UIColor = UIColor(named: "DefaultBackground")!
    var foregroundColor: UIColor = UIColor(named: "DefaultForeground")!
    var primaryColor: UIColor = UIColor(named: "DefaultPrimary")!
    var secondaryColor: UIColor = UIColor(named: "DefaultSecondary")!
    var themeName: String = "Default"
}

struct Theme1: Theme {
    var backgroundColor: UIColor = UIColor(named: "LilaBackground")!
    var foregroundColor: UIColor = UIColor(named: "LilaForeground")!
    var primaryColor: UIColor = UIColor(named: "LilaPrimary")!
    var secondaryColor: UIColor = UIColor(named: "LilaSecondary")!
    var themeName: String = "Lila"
}

struct Theme2: Theme {
    var backgroundColor: UIColor = UIColor(named: "BlueBackground")!
    var foregroundColor: UIColor = UIColor(named: "BlueForeground")!
    var primaryColor: UIColor = UIColor(named: "BluePrimary")!
    var secondaryColor: UIColor = UIColor(named: "BlueSecondary")!
    var themeName: String = "Blue"
}
