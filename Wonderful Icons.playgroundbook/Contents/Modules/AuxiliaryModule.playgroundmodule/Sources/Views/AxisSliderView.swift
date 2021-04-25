//
//  File.swift
//  BookCore
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI

public struct AxisSliderView: View {
    @Binding var axisValue: CGFloat
    
    let label: String
    let range: ClosedRange<CGFloat>
    let isShowingZeroButton: Bool
    
    public init(axisValue: Binding<CGFloat>, range: ClosedRange<CGFloat>, isShowingZeroButton: Bool, label: String) {
        self._axisValue = axisValue
        self.label = label
        self.range = range
        self.isShowingZeroButton = isShowingZeroButton
    }
    
    public var body: some View {
        let binding = Binding(
            get: { self.axisValue },
            set: { self.axisValue = $0 }
        )
        
        HStack {
            Text(label)
            
            Slider(value: binding.animation(), in: range)
            
            if isShowingZeroButton {
                Button(action: {
                    withAnimation(.spring()) {
                        axisValue = 0
                    }
                }, label: {
                    Text("0")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .buttonStyle(PlainButtonStyle())
                .disabled(axisValue == 0)
            }
        }
    }
}
