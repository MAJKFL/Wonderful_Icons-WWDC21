//
//  DesigningAnimatedLiveView.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI

public struct DesigningAnimatedLiveView: View {
    enum AnimationType {
        case changingIcon
        case padding
        case gradientColors
    }
    
    let timer = Timer.publish(every: 3, on: .current, in: .common).autoconnect()
    
    @State private var animationType = AnimationType.changingIcon
    
    public init() {
        
    }
    
    public var body: some View {
        Section {
            switch animationType {
            case .changingIcon:
                AnimatedIconChangingGlyphView(size: 256)
                    .transition(AnyTransition.opacity.combined(with: .slide))
            case .padding:
                AnimatedIconChangingImageSizeView(size: 256)
                    .transition(AnyTransition.opacity.combined(with: .slide))
            default:
                AnimatedIconChangingColorsView(size: 256)
                    .transition(AnyTransition.opacity.combined(with: .slide))
            }
        }
        .onTapGesture {
            changeEditor()
        }
        .onReceive(timer, perform: { _ in
            changeEditor()
        })
    }
    
    func changeEditor() {
        withAnimation(.easeOut) {
            switch animationType {
            case .changingIcon:
                animationType = .padding
            case .padding:
                animationType = .gradientColors
            default:
                animationType = .changingIcon
            }
        }
    }
}
