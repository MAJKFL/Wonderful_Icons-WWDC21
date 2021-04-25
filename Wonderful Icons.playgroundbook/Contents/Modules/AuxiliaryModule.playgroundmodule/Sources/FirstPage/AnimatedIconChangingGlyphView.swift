//
//  AnimatedIconChangingGlyphView.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI
import Combine

public struct AnimatedIconChangingGlyphView: View {
    let names = ["chicken", "envelope", "guitar", "horn", "postageStamp", "star", "swift"]
    @State private var firstSelectedImageName = "guitar"
    @State private var secondSelectedImageName = "horn"
    let size: CGFloat
    
    @State private var showFirst = true
    @State private var counter = 0
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    let gradient: Gradient
    
    public init(size: CGFloat) {
        self.size = size
        self.gradient = Gradient(colors: [Color.random(), Color.random()])
        
        timer = Timer.publish(every: size == 256 ? 0.75 : 1.5, on: .current, in: .common).autoconnect()
    }
    
    public var body: some View {
        VStack {
            Text("Pick glyph")
                .font(.largeTitle)
            
            Section {
                if showFirst {
                    Image(uiImage: UIImage(named: firstSelectedImageName)!)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                } else {
                    Image(uiImage: UIImage(named: secondSelectedImageName)!)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(width: size, height: size)
            .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: size * 0.227, style: .continuous))
            .shadow(radius: 5)
            .transition(.opacity)
        }
        .onReceive(timer, perform: { _ in
            randomImage()
        })
    }
    
    func randomImage() {
        if counter < 3 || size != 256 {
            withAnimation {
                showFirst.toggle()
            }
            
            var namesWithout = names
            namesWithout.removeAll(where: { $0 == secondSelectedImageName || $0 == firstSelectedImageName })
            
            if showFirst {
                secondSelectedImageName = namesWithout.randomElement()!
            } else {
                firstSelectedImageName = namesWithout.randomElement()!
            }
        }
        counter += 1
    }
}
