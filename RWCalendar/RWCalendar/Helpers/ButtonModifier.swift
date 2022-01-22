//
//  ButtonModifier.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2021/12/25.
//

import SwiftUI

struct FilledRoundedCornerButtonStyle: ButtonStyle {
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
        configuration.label
            .font(font)
            .frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight)
            .padding(padding)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(primaryColor, lineWidth: 2))
            .border(primaryColor)
            .cornerRadius(cornerRadius)
            //.shadow(radius:5)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
