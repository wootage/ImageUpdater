//
//  ProfileImage.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 26/10/2023.
//

import SwiftUI

struct ProfileImage: View {
    let imageState: ImageState
    var style: Style = .circular
    
    @ViewBuilder private var centerView: some View {
        switch imageState {
        case .empty:
            Image(systemName: "person.fill")
                .applyProfileImageStyle()
                .foregroundStyle(.primary)
                .background(Color.secondary)
        case .loading(_):
            ProgressView()
        case .success(let image, _):
            image
                .resizable()
                .scaledToFill()
        case .initials(let model):
            Text(model.title)
                .applyProfileImageStyle()
                .background { model.color }
        case .failure(_):
            Image(systemName: "explamation.mark.fill")
                .applyProfileImageStyle()
                .foregroundStyle(.primary)
                .background(Color.secondary)
        }
    }
    
    var body: some View {
        centerView
            .clip(with: style)
    }
}

#Preview {
    ProfileImage(imageState: .empty)
        .frame(width: 100, height: 100)
}
