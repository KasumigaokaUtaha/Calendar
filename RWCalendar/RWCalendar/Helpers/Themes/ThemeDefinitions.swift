//
//  ThemeDefinitions.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2021/12/24.
//

import UIKit

// Define the structure for different themes

struct Theme0: Theme {
    var backgroundColor = UIColor(named: "DefaultBackground")!
    var foregroundColor = UIColor(named: "DefaultForeground")!
    var primaryColor = UIColor(named: "DefaultPrimary")!
    var secondaryColor = UIColor(named: "DefaultSecondary")!
    var themeName = NSLocalizedString("theme_default", comment: "Default Theme")
}

struct Theme1: Theme {
    var backgroundColor = UIColor(named: "LilaBackground")!
    var foregroundColor = UIColor(named: "LilaForeground")!
    var primaryColor = UIColor(named: "LilaPrimary")!
    var secondaryColor = UIColor(named: "LilaSecondary")!
    var themeName = NSLocalizedString("theme_lila", comment: "Lila Theme")
}

struct Theme2: Theme {
    var backgroundColor = UIColor(named: "BlueBackground")!
    var foregroundColor = UIColor(named: "BlueForeground")!
    var primaryColor = UIColor(named: "BluePrimary")!
    var secondaryColor = UIColor(named: "BlueSecondary")!
    var themeName = NSLocalizedString("theme_blue", comment: "Blue Theme")
}
