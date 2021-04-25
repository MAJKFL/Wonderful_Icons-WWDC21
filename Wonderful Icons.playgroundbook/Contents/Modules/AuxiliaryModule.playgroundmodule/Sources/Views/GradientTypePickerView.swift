//
//  GradientTypePickerView.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI

public enum GradientType: String, CaseIterable {
    case linear
    case radial
}

public struct GradientTypePickerView: View {
    @Namespace private var animation
    @Binding var gradientType: GradientType
    
    public init(gradientType: Binding<GradientType>) {
        self._gradientType = gradientType
    }
    
    public var body: some View {
        HStack {
            ZStack {
                if gradientType == .linear {
                    Text("Linear")
                        .foregroundColor(.clear)
                        .padding(10)
                        .background(Color.secondary)
                        .clipShape(Capsule())
                        .matchedGeometryEffect(id: "effect", in: animation)
                }
                
                Button("Linear", action: {
                    withAnimation(.spring()) {
                        gradientType = .linear
                    }
                })
                .foregroundColor(.white)
                .padding(10)
                .background(Color.secondary.opacity(0.5))
                .clipShape(Capsule())
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
            
            ZStack {
                if gradientType == .radial {
                    Text("Radial")
                        .foregroundColor(.clear)
                        .padding(10)
                        .background(Color.secondary)
                        .clipShape(Capsule())
                        .matchedGeometryEffect(id: "effect", in: animation)
                }
                
                Button("Radial", action: {
                    withAnimation(.spring()) {
                        gradientType = .radial
                    }
                })
                .foregroundColor(.white)
                .padding(10)
                .background(Color.secondary.opacity(0.5))
                .clipShape(Capsule())
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
    }
}
