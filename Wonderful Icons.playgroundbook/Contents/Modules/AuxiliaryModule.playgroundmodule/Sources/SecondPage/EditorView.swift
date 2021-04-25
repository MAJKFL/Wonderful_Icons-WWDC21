//
//  EditorView.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI
import AVFoundation

public struct EditorView: View {
    let image: UIImage
    let paletteOfColors: [UIColor]
    
    @State private var editorMode = EditorMode.colors
    
    @State private var paddingAmount: Int = 30
    @State private var gradientColors = [Color.white, Color.white]
    @State private var imageColor = Color.black
    
    @State private var isShowingGrid: Bool = false
    @State private var isGridColorInverted = false
    @State private var displayAsOriginal = false
    @State private var imageRotation: CGFloat = 0
    @State private var imageX: CGFloat = 0
    @State private var imageY: CGFloat = 0
    
    @State private var gradientType = GradientType.linear
    @State private var gradientBlur: CGFloat = 0
    @State private var gradientRotation: CGFloat = 0
    @State private var gradientStartRadius: CGFloat = 5
    @State private var gradientEndRadius: CGFloat = 175
    
    @State private var isShowingSaveAlert = false
    
    @State private var isShowingCameraFlash = false
    @State private var isReadyForSave = true
    
    @State private var cameraShutterSoundEffect: AVAudioPlayer?
    
    public init(image: UIImage, paletteOfColors: [UIColor]) {
        self.image = image
        self.paletteOfColors = paletteOfColors
    }
    
    var colors: [UIColor] {
        var col = [UIColor]()
        for color in paletteOfColors {
            let components = color.components
            col.append(UIColor(red: components.red, green: components.green, blue: components.blue, alpha: 1))
        }
        return col
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
    
    var gradient: Gradient {
        Gradient(colors: gradientColors)
    }
    
    public var body: some View {
        VStack {
            Text("Design your icon!")
                .font(.title)
            
            EditorModePickerView(editorMode: $editorMode, values: EditorMode.allCases)
                .padding(.bottom)
            
            iconWithRoundedEdges
            
            switch editorMode {
            case .colors:
                colorEditorMode
            case .image:
                imageEditorMode
            case .placement:
                gradientEditor
            default:
                settings
            }
        }
        .frame(width: 300)
        .padding(.top, 50)
    }
    
    func saveImage() {
        if isReadyForSave {
            let path = Bundle.main.path(forResource: "cameraShutter.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)

            do {
                cameraShutterSoundEffect = try AVAudioPlayer(contentsOf: url)
                cameraShutterSoundEffect?.play()
            } catch {
            }
            
            let image = iconWithSquareEdges.snapshot()
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            withAnimation(Animation.easeOut(duration: 0.2)) {
                isShowingCameraFlash = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(Animation.easeOut(duration: 2)) {
                    isShowingCameraFlash = false
                }
            }
            isReadyForSave = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isReadyForSave = true
        }
    }
}

extension EditorView {
    var iconWithRoundedEdges: some View {
        ZStack {
            iconWithSquareEdges
            
            Image(uiImage: UIImage(named: "template")!)
                .resizable()
                .scaledToFit()
                .opacity(isShowingGrid ? 1 : 0)
                .isInvertedColor(isGridColorInverted)
            
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
            if gradientType == .linear {
                LinearGradient(gradient: gradient, startPoint: firstGradientStartPoint, endPoint: secondGradientStartPoint)
                    .scaleEffect(1 + gradientBlur / 90)
                    .blur(radius: gradientBlur)
            } else {
                RadialGradient(gradient: gradient, center: .center, startRadius: gradientStartRadius, endRadius: gradientEndRadius)
                    .scaleEffect(1 + gradientBlur / 90)
                    .blur(radius: gradientBlur)
            }
            
            Image(uiImage: image)
                .renderingMode(displayAsOriginal ? .original : .template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .colorMultiply(displayAsOriginal ? .white : imageColor)
                .rotationEffect(Angle(degrees: Double(imageRotation)))
                .padding(CGFloat(paddingAmount))
                .offset(x: imageX, y: imageY)
        }
        .frame(width: 256, height: 256)
    }
}

extension EditorView {
    var colorEditorMode: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("First color")
                
                gridColorPicker(selectedColor: $gradientColors[0], colorArray: colors)
                
                Divider()
                    .padding(.horizontal)
                
                Text("Second color")
                
                gridColorPicker(selectedColor: $gradientColors[1], colorArray: colors)
                
                Divider()
                    .padding(.horizontal)
                
                Text("Image color")
                    .opacity(displayAsOriginal ? 0.5 : 1)
                
                gridColorPicker(selectedColor: $imageColor, colorArray: colors)
                    .disabled(displayAsOriginal)
                    .opacity(displayAsOriginal ? 0.5 : 1)
            }
            .padding(.horizontal, 5)
        }
        .transition(AnyTransition.opacity.combined(with: .slide))
    }
    
    var imageEditorMode: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Stepper("Add padding", onIncrement: {
                    if paddingAmount < 100 {
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
                
                VStack {
                    Divider()
                        .padding(.horizontal)
                    
                    Text("Rotation")
                    
                    AxisSliderView(axisValue: $imageRotation, range: 0...360, isShowingZeroButton: true, label: "")
                }
                .padding(.bottom, 5)
                
                Divider()
                    .padding(.horizontal)
                
                VStack {
                    Text("Offset")
                    
                    AxisSliderView(axisValue: $imageX, range: -128...128, isShowingZeroButton: true, label: "X")
                    
                    AxisSliderView(axisValue: $imageY, range: -128...128, isShowingZeroButton: true, label: "Y")
                }
            }
            .padding(.horizontal, 5)
        }
        .transition(AnyTransition.opacity.combined(with: .slide))
    }
    
    var gradientEditor: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Gradient type")
                
                GradientTypePickerView(gradientType: $gradientType)
                
                Divider()
                    .padding(.horizontal)
                
                Text("Blur")
                
                AxisSliderView(axisValue: $gradientBlur, range: 0...30, isShowingZeroButton: true, label: "")
                    .padding(.bottom, 5)
                
                Divider()
                    .padding(.horizontal)
                
                if gradientType == .linear {
                    VStack {
                        Text("Gradient rotation")
                        
                        AxisSliderView(axisValue: $gradientRotation, range: -175...175, isShowingZeroButton: true, label: "")
                    }
                    .transition(AnyTransition.opacity.combined(with: .move(edge: .leading)))
                } else {
                    VStack {
                        Text("Start radius")
                        
                        AxisSliderView(axisValue: $gradientStartRadius, range: 0...100, isShowingZeroButton: false, label: "")
                        
                        Text("End radius")
                        
                        AxisSliderView(axisValue: $gradientEndRadius, range: 50...300, isShowingZeroButton: false, label: "")
                    }
                    .transition(AnyTransition.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .padding(.horizontal, 5)
        }
        .transition(AnyTransition.opacity.combined(with: .slide))
    }
    
    var settings: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Toggle("Show grid", isOn: $isShowingGrid.animation(.easeOut))
                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                
                if isShowingGrid {
                    Toggle("Invert grid color", isOn: $isGridColorInverted.animation(.easeOut))
                        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
                
                Divider()
                    .padding(.horizontal)
                
                Toggle("Display as original", isOn: $displayAsOriginal.animation(.easeOut))
                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                
                Divider()
                    .padding(.horizontal)
                
                Button(action: {
                    saveImage()
                }, label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                })
                .font(.title)
            }
            .padding(.horizontal, 5)
        }
        .transition(AnyTransition.opacity.combined(with: .slide))
    }
}
