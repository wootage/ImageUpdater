//
//  LogoChangerView.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 25/10/2023.
//

import SwiftUI

struct LogoChangerView: View {
    
    @State private var isShowingSheet = false
    @State private var state: ImageState = .empty
    
    var imageStyle: Style = .circular
    
    var body: some View {
        
        VStack {
            ProfileImage(imageState: state, style: imageStyle)
                .onTapGesture {
                    isShowingSheet = true
                }
        }
        .sheet(isPresented: $isShowingSheet) {
            ImageSelectionView(state, imageStyle: imageStyle) { state in
                self.state = state
            }
        }
    }
}

#Preview {
    LogoChangerView()
}
