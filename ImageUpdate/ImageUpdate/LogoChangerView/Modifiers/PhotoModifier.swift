//
//  PhotoModifier.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 26/10/2023.
//

import SwiftUI

struct PhotoModifier<S: Shape>: ViewModifier {
    
    let color: Color
    let shape: S
    
    func body(content: Content) -> some View {
        return content
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background { color.opacity(0.3) }
            .clipShape(shape)
            .buttonStyle(PlainButtonStyle())
            .overlay() {
                shape
                    .stroke(color, lineWidth: 1)
            }
            .foregroundStyle(color)
            .font(.system(size: 24))
    }
}

extension View {
    func photoStyle<S>(color: Color,
                       shape: S = Circle()) -> some View where S: Shape {
        return self.modifier(PhotoModifier(color: color, shape: shape))
    }
    
    func photoStyle(color: Color,
                    style: Style) -> some View {
        return self.modifier(PhotoModifier(color: color,
                                           shape: style.clipShape))
    }
}
