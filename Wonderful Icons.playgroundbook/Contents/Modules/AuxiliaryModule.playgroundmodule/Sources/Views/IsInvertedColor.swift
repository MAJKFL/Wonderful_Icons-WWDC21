//
//  IsInvertedColor.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI

public struct IsInvertedColor: ViewModifier {
    let isInverted: Bool
    
    public func body(content: Content) -> some View {
        Section {
            if isInverted {
                content.colorInvert()
            } else {
                content
            }
        }
    }
}

public extension View {
    func isInvertedColor(_ isInverted: Bool) -> some View {
        self.modifier(IsInvertedColor(isInverted: isInverted))
    }
}
