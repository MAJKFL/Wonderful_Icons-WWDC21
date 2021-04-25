//
//  CreatingIconAnimatedLiveView.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI

public struct CreatingIconAnimatedLiveView: View {
    let names = ["chicken", "envelope", "guitar", "horn", "postageStamp", "star", "swift"]
    @State private var editorMode = EditorMode.colors
    
    @State private var gradientA: [Color] = [.red, .purple]
    @State private var gradientB: [Color] = [.red, .purple]
    @State private var firstPlane: Bool = true
    
    @State private var imageColor = Color.black
    
    @State private var paddingAmount: Int = 30
    @State private var imageRotation: CGFloat = 0
    @State private var imageX: CGFloat = 0
    @State private var imageY: CGFloat = 0
    
    @State private var gradientRotation: CGFloat = 0
    
    @State private var isShowingGrid: Bool = false
    @State private var isGridColorInverted = false
    
    @State private var isShowingCameraFlash = false
    
    let editorModeTimer = Timer.publish(every: 3, on: .current, in: .common).autoconnect()
    let changeSettingsTimer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    @State private var image = UIImage(named: "star")
    
    public init() {
        image = UIImage(named: names.randomElement()!)!
    }
    
    var firstGradientStartPoint: UnitPoint {
        switch gradientRotation {
        case -45..<0:
            return UnitPoint(x: 0.5 - gradientRotation / -90, y: 1)
        case -135..<(-45):
            return UnitPoint(x: 0, y: 1 - (-1 * gradientRotation - 45) / 90)
        case -180..<(-135):
            return UnitPoint(x: (-1 * gradientRotation - 135) / 90, y: 0)
        case 0..<45:
            return UnitPoint(x: gradientRotation / 90 + 0.5, y: 1)
        case 45..<135:
            return UnitPoint(x: 1, y: 1 - (gradientRotation - 45) / 90)
        default:
            return UnitPoint(x: 1.0 - (gradientRotation - 135) / 90, y: 0)
        }
    }
    
    var secondGradientStartPoint: UnitPoint {
        return UnitPoint(x: 1 - firstGradientStartPoint.x, y: 1 - firstGradientStartPoint.y)
    }
    
    public var body: some View {
        VStack {
            Text("Design your icon!")
                .font(.title)
            
            EditorModePickerView(editorMode: $editorMode, values: EditorMode.allCases)
                .disabled(true)
                .padding(.bottom)
            
            iconWithRoundedEdges
                .onTapGesture {
                    nextEditorMode()
                }
        }
        .frame(width: 300)
        .onReceive(editorModeTimer, perform: { _ in
            nextEditorMode()
        })
        .onReceive(changeSettingsTimer, perform: { _ in
            changeSettings()
        })
    }
    
    func nextEditorMode() {
        withAnimation(.easeInOut) {
            switch editorMode {
            case .colors:
                editorMode = .image
            case .image:
                editorMode = .placement
                imageRotation = 0
                imageX = 0
                imageY = 0
            case .placement:
                editorMode = .settings
                
                withAnimation(Animation.easeOut(duration: 0.2)) {
                    isShowingCameraFlash = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(Animation.easeOut(duration: 2)) {
                        isShowingCameraFlash = false
                    }
                }
            default:
                editorMode = .colors
                isShowingGrid = false
                image = UIImage(named: names.randomElement()!)!
            }
        }
    }
    
    func changeSettings() {
        withAnimation(.easeInOut) {
            switch editorMode {
            case .colors:
                setGradients()
                setImageColor()
            case .image:
                paddingAmount = Int.random(in: 0...80)
                imageRotation = CGFloat.random(in: 0...45)
                imageX = CGFloat.random(in: (CGFloat(paddingAmount) / -2)...(CGFloat(paddingAmount) / 2))
                imageY = CGFloat.random(in: (CGFloat(paddingAmount) / -2)...(CGFloat(paddingAmount) / 2))
            case .placement:
                gradientRotation = CGFloat.random(in: -160...160)
            default:
                isShowingGrid = true
            }
        }
    }
    
    func setImageColor() {
        var colorBetween = UIColor.white
        if firstPlane {
            colorBetween = UIColor(gradientA[0]).toColor(UIColor(gradientA[1]), percentage: 50)
        } else {
            colorBetween = UIColor(gradientB[0]).toColor(UIColor(gradientB[1]), percentage: 50)
        }
        let distanceBetweenWhite = colorBetween.colorDistanceBetween(uicolor: UIColor.white)
        let distanceBetweenBlack = colorBetween.colorDistanceBetween(uicolor: UIColor.black)
        
        if distanceBetweenWhite > distanceBetweenBlack {
            imageColor = Color(white: Double.random(in: 0.7...1))
        } else {
            imageColor = Color(white: Double.random(in: 0...0.3))
        }
    }
    
    func setGradient(gradient: [Color]) {
        if firstPlane {
            gradientB = gradient
        }
        else {
            gradientA = gradient
        }
        firstPlane = !firstPlane
    }
    
    func setGradients() {
        withAnimation(.easeOut) {
            self.setGradient(gradient: [Color.random(), Color.random()])
        }
    }
}

extension CreatingIconAnimatedLiveView {
    var iconWithRoundedEdges: some View {
        ZStack {
            iconWithSquareEdges
            
            Image(uiImage: UIImage(named: "template")!)
                .resizable()
                .scaledToFit()
                .opacity(isShowingGrid ? 1 : 0)
            
            ZStack {
                Color.white
                
                Image(systemName: "camera.viewfinder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 128, height: 128)
                    .foregroundColor(.secondary)
            }
                .opacity(isShowingCameraFlash ? 1 : 0)
        }
        .frame(width: 256, height: 256)
        .clipShape(RoundedRectangle(cornerRadius: 57.2672, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 57.2672, style: .continuous)
                .stroke(Color.secondary.opacity(0.5), style: StrokeStyle(lineWidth: 2))
        )
        .shadow(radius: 15)
    }
    
    var iconWithSquareEdges: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 57.2672)
                .fill(LinearGradient(gradient: Gradient(colors: self.gradientA), startPoint: firstGradientStartPoint, endPoint: secondGradientStartPoint))
            RoundedRectangle(cornerRadius: 57.2672)
                .fill(LinearGradient(gradient: Gradient(colors: self.gradientB), startPoint: firstGradientStartPoint, endPoint: secondGradientStartPoint))
                .opacity(self.firstPlane ? 0 : 1)
            
            Image(uiImage: image!)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .colorMultiply(imageColor)
                .rotationEffect(Angle(degrees: Double(imageRotation)))
                .padding(CGFloat(paddingAmount))
                .offset(x: imageX, y: imageY)
        }
        .frame(width: 256, height: 256)
    }
}
