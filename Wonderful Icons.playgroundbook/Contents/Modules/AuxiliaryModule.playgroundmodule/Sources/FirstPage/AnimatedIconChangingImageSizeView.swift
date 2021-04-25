//
//  AnimatedIconChangingImageSizeView.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI
import Combine

public struct AnimatedIconChangingImageSizeView: View {
    let names = ["chicken", "envelope", "guitar", "horn", "postageStamp", "star", "swift"]
    let name: String
    
    let size: CGFloat
    
    let gradient: Gradient
    
    @State private var imagePadding: CGFloat = 0
    @State private var isShowingGrid = true
    @State private var counter = 0
    
    let timerPadding: Publishers.Autoconnect<Timer.TimerPublisher>
    let timerGrid: Publishers.Autoconnect<Timer.TimerPublisher>
    
    public init(size: CGFloat) {
        self.size = size
        self.name = names.randomElement()!
        self.gradient = Gradient(colors: [Color.random(), Color.random()])
        
        timerPadding = Timer.publish(every: size == 256 ? 0.75 : 1.5, on: .current, in: .common).autoconnect()
        timerGrid = Timer.publish(every: size == 256 ? 1.5 : 3, on: .current, in: .common).autoconnect()
    }
    
    public var body: some View {
        VStack {
            Text("Add padding")
                .font(.largeTitle)
            
            ZStack {
                LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
                
                Image(uiImage: UIImage(named: name)!)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .colorMultiply(.white)
                    .padding(imagePadding)
                
                Image(uiImage: UIImage(named: "template")!)
                    .resizable()
                    .scaledToFit()
                    .opacity(isShowingGrid ? 1 : 0)
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.227))
            .shadow(radius: 5)
        }
        .onReceive(timerPadding) { _ in setImagePadding() }
        .onReceive(timerGrid) { _ in setIsShowingGrid() }
    }
    
    func setImagePadding() {
        if counter < 3 || size != 256 {
            withAnimation(.easeOut) {
                switch imagePadding {
                case size / 4...size / 3:
                    imagePadding = CGFloat.random(in: size / 13...size / 10) // 2
                case size / 13...size / 10:
                    imagePadding = size / 7 // 3
                default:
                    imagePadding = CGFloat.random(in: size / 4...size / 3) // 1
                }
            }
        }
        counter += 1
    }
    
    func setIsShowingGrid() {
        withAnimation(Animation.easeOut(duration: 1.5)) {
            isShowingGrid.toggle()
        }
    }
}
