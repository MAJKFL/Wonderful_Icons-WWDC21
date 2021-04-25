//
//  GridColorPicker.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI

public struct gridColorPicker: View {
    @Binding var selectedColor: Color
    
    let colorArray: [UIColor]
    
    var colors: [Color] {
        colorArray.map { Color($0) }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    public init(selectedColor: Binding<Color>, colorArray: [UIColor]) {
        self._selectedColor = selectedColor
        self.colorArray = colorArray
    }
    
    public var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(colors, id: \.self) { color in
                Button(action: {
                    withAnimation {
                        selectedColor = color
                    }
                }, label: {
                    color
                        .frame(height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(Color.secondary.opacity(selectedColor == color ? 1 : 0.5), style: StrokeStyle(lineWidth: selectedColor == color ? 2 : 1))
                        )
                        .shadow(radius: 5)
                })
            }
        }
    }
}
