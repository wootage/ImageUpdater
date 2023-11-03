//
//  ProfileImageModifier.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 02/11/2023.
//

import SwiftUI

struct ProfileImageModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        return content
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .font(.system(size: 48, weight: .bold))
            .minimumScaleFactor(0.1)
            .padding(4)
    }
}

extension View {
    func applyProfileImageStyle() -> some View {
        return self.modifier(ProfileImageModifier())
    }
}
