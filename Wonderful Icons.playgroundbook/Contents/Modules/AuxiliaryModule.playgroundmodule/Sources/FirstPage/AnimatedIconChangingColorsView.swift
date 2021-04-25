//
//  AnimatedIconChangingColorsView.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI
import Combine

public struct AnimatedIconChangingColorsView: View {
    let names = ["chicken", "envelope", "guitar", "horn", "postageStamp", "star", "swift"]
    let name: String
    
    @State private var gradientA: [Color] = [.red, .purple]
    @State private var gradientB: [Color] = [.red, .purple]
    
    @State private var firstPlane: Bool = true
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let size: CGFloat
    
    func setGradient(gradient: [Color]) {
        if firstPlane {
            gradientB = gradient
        }
        else {
            gradientA = gradient
        }
        firstPlane = !firstPlane
    }
    
    public init(size: CGFloat) {
        self.size = size
        self.name = names.randomElement()!
        timer = Timer.publish(every: size == 256 ? 0.75 : 1.5, on: .current, in: .common).autoconnect()
    }
    
    public var body: some View {
        VStack {
            Text("Create background")
                .font(.largeTitle)
            
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.227)
                    .fill(LinearGradient(gradient: Gradient(colors: self.gradientA), startPoint: .top, endPoint: .bottom))
                RoundedRectangle(cornerRadius: size * 0.227)
                    .fill(LinearGradient(gradient: Gradient(colors: self.gradientB), startPoint: .top, endPoint: .bottom))
                    .opacity(self.firstPlane ? 0 : 1)
                
                Image(uiImage: UIImage(named: name)!)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.227))
            .shadow(radius: 5)
        }
        .onReceive(timer) { _ in setGradients() }
    }
    
    func setGradients() {
        withAnimation(.easeOut) {
            self.setGradient(gradient: [Color.random(), Color.random()])
        }
    }
}
