//
//  FrameModifier.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 31/10/2023.
//

import SwiftUI

fileprivate enum Constants {
    static let maxOSXWidth: CGFloat = 560.0
    static let maxOSXHeight: CGFloat = 560.0
}

struct MacOSFrameModifier: ViewModifier {
    
    let width: CGFloat
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
#if targetEnvironment(macCatalyst)
            .frame(width: width,
                   height: height)
#endif
    }
}

extension View {
    
    func macOSFrame(width: CGFloat,
                    height: CGFloat) -> some View {
        return self.modifier(MacOSFrameModifier(width: width,
                                                height: height))
    }
    
    func fixateMacOSFrame() -> some View {
        macOSFrame(width: Constants.maxOSXWidth,
                   height: Constants.maxOSXHeight)
    }
}
