//
//  EditorModePickerView.swift
//  PlaygroundBook
//
//  Created by Kuba Florek on 17/04/2021.
//

import SwiftUI

public enum EditorMode: String, CaseIterable {
    case colors = "camera.filters"
    case image = "photo"
    case placement = "slider.horizontal.3"
    case settings = "wrench.and.screwdriver"
}

public struct EditorModePickerView: View {
    @Namespace private var animation
    @Binding var editorMode: EditorMode
    let values: [EditorMode]
    
    public init(editorMode: Binding<EditorMode>, values: [EditorMode]) {
        self._editorMode = editorMode
        self.values = values
    }
    
    public var body: some View {
        HStack {
            Spacer()
                
            ForEach(values, id: \.self) { mode in
                ZStack {
                    if mode == editorMode {
                        Image(systemName: "house")
                            .foregroundColor(.clear)
                            .frame(width: 35, height: 35)
                            .background(Color.secondary)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .matchedGeometryEffect(id: "Background", in: animation)
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            editorMode = mode
                        }
                    }, label: {
                        Image(systemName: mode.rawValue)
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(Color.secondary.opacity(0.5))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
            }
        }
    }
}
