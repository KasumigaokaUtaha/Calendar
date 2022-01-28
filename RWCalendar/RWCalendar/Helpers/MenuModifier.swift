//
//  MenuModifier.swift
//  RWCalendar
//
//  Created by Liangkun He on 28.01.22.
//

import SwiftUI

struct customMenuStyle: MenuStyle {
    var font: Font = .body
    var padding: CGFloat = 10

    var minWidth: CGFloat = 0
    var maxWidth: CGFloat = .infinity
    var minHeight: CGFloat = 0
    var maxHeight: CGFloat = .infinity

    var backgroundColor = Color(.white)
    var foregroundColor = Color(.black)
    var primaryColor = Color(.red)
    var secondaryColor = Color(.yellow)
    var cornerRadius: CGFloat = 8

    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .font(font)
            .frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight)
            .padding(padding)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(primaryColor, lineWidth: 2)
            )
            .border(primaryColor)
            .cornerRadius(cornerRadius)
    }
}
