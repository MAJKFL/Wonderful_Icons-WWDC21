//
//  DesigningView.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI

public struct DesigningView: View {
    let showColorPicker: Bool
    let showImageSizeManipulator: Bool
    let image: UIImage
    
    @State private var isShowingGrid: Bool = false
    @State private var paddingAmount = 0
    @State private var gradientColors = [Color.gray, Color.gray]
    
    let defaultGradient: Gradient
    
    public init(image: UIImage, showImageSizeManipulator: Bool, showColorPicker: Bool) {
        self.image = image
        self.showImageSizeManipulator = showImageSizeManipulator
        self.showColorPicker = showColorPicker
        self.defaultGradient = Gradient(colors: [Color.random(), Color.random()])
    }
    
    let paletteOfColors: [UIColor] = [
        #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
        #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
        #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
        #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),
        #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
        #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    ]
    
    var gradient: Gradient {
        Gradient(colors: gradientColors)
    }
    
    var editorMode: EditorMode {
        if showColorPicker {
            return .colors
        } else {
            return .image
        }
    }
    
    public var body: some View {
        VStack {
            if showColorPicker {
                AnimatedIconChangingColorsView(size: 128)
            } else if showImageSizeManipulator {
                AnimatedIconChangingImageSizeView(size: 128)
            } else {
                AnimatedIconChangingGlyphView(size: 128)
            }
            
            Divider()
                .frame(width: 200)
            
            ZStack {
                LinearGradient(gradient: showColorPicker ? gradient : defaultGradient, startPoint: .top, endPoint: .bottom)
                
                Image(uiImage: image)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(showColorPicker ? 30 : CGFloat(paddingAmount))
                
                Image(uiImage: UIImage(named: "template")!)
                    .resizable()
                    .scaledToFit()
                    .opacity(isShowingGrid ? 1 : 0)
            }
            .frame(width: 256, height: 256)
            .clipShape(RoundedRectangle(cornerRadius: 57.2672, style: .continuous))
            .shadow(radius: 5)
            
            if editorMode == EditorMode.image {
                if showImageSizeManipulator {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Toggle("Show grid", isOn: $isShowingGrid.animation(.easeOut))
                            
                            Divider()
                                .padding(.horizontal)
                            
                            Stepper("Add padding", onIncrement: {
                                if paddingAmount < 70 {
                                    withAnimation {
                                        paddingAmount += 5
                                    }
                                }
                            }, onDecrement: {
                                if paddingAmount > 0 {
                                    withAnimation(.spring()) {
                                        paddingAmount -= 5
                                    }
                                }
                            })
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: 300)
                    .transition(AnyTransition.opacity.combined(with: .slide))
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        Text("First color")
                        
                        gridColorPicker(selectedColor: $gradientColors[0], colorArray: paletteOfColors)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        Text("Second color")
                        
                        gridColorPicker(selectedColor: $gradientColors[1], colorArray: paletteOfColors)
                    }
                    .padding(.horizontal)
                }
                .frame(width: 300)
                .transition(AnyTransition.opacity.combined(with: .slide))
            }
        }
        .padding(.top, 50)
    }
}
