//
//  ShapeModifier.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 01/11/2023.
//

import SwiftUI

enum Style {
    case circular
    case rectangular(CGFloat)
    
    var clipShape: AnyShape {
        switch self {
        case .circular:
            AnyShape(Circle())
        case .rectangular(let radius):
            AnyShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}

struct ShapeModifier<S: Shape>: ViewModifier {
    
    let shape: S
    
    func body(content: Content) -> some View {
        return content
            .clipShape(shape)
            .contentShape(shape)
    }
}

extension View {
    func clip(with style: Style) -> some View {
        return self.modifier(ShapeModifier(shape: style.clipShape))
    }
}
