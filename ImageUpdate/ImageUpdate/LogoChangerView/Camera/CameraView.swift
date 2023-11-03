//
//  CameraView.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 31/10/2023.
//

import SwiftUI

struct CameraView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var camera: CameraModel = CameraModel()
    
    @Binding var selectedImage: Image?
    
    @ViewBuilder private var actionButton: some View {
        if camera.image == nil {
            Button(action: {
                camera.captureImage()
            }, label: {
                Image(systemName: "camera.circle")
                    .resizable()
                    .frame(width: 44,
                           height: 44)
            })
            .buttonStyle(.plain)
            .padding(16)
        }
        else {
            Button("Retake",
                   action: {
                camera.retake()
            })
            .padding(16)
            .foregroundStyle(.tint)
        }
    }
    
    var body: some View {
        ZStack {
            
            if let image = camera.image {
                image
                    .resizable()
                    .scaledToFit()
            }
            else {
                CameraLayer(previewLayer: camera.cameraPreviewLayer)
            }
            
            VStack {
                
                HStack {
                    Button("Cancel",
                           action: {
                        dismiss()
                    })
                    .foregroundStyle(.tint)
                    
                    Spacer()
                    
                    if camera.image != nil {
                        Button("Use",
                               action: {
                            selectedImage = camera.image
                            dismiss()
                        })
                        .foregroundStyle(.tint)
                    }
                }
                .padding(16)
                .background { Color.black.opacity(0.4) }
                
                Spacer()
                
                Color.black.opacity(0.4)
                    .frame(height: 96)
                    .ignoresSafeArea()
                    .overlay(alignment: .top) {
                        actionButton
                    }
            }
        }
        .onAppear() {
            camera.setup()
        }
        .onDisappear() {
            camera.stop()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CameraView(selectedImage: .constant(nil))
}
