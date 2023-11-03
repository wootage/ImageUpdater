//
//  ImageSelectionView.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 26/10/2023.
//

import SwiftUI
import PhotosUI

struct ImageSelectionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: ViewModel
    private var style: Style
    
    @State private var isPhotosPickerPresented: Bool = false
    @State private var isCameraPickerPresented: Bool = false
    @State private var isInitialsPickerPresented: Bool = false
    
    private var completion: ((ImageState) -> Void)?
    
    private let columns: [GridItem] = Array(repeating:
                                                GridItem(.flexible(),
                                                         spacing: 16),
                                            count: 5)
    
    @ViewBuilder private var recentlyUsedView: some View {
        ScrollView() {
            
            if viewModel.recentlyUsed.count > 0 {
                Text("Recently used:")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.horizontal)
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(viewModel.recentlyUsed), id: \.self) { item in
                    ProfileImage(imageState: item, style: style)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            viewModel.updateImageState(item)
                        }
                }
            }
            .padding()
        }
    }
    
    init(_ state: ImageState,
         imageStyle: Style,
         completion: ((ImageState) -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: ViewModel(state))
        self.style = imageStyle
        self.completion = completion
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button("Cancel",
                       action: {
                    dismiss()
                })
                
                Spacer()
                
                Button("Save",
                       action: {
                    completion?(viewModel.imageState)
                    dismiss()
                })
            }
            .padding(16)
            
            ProfileImage(imageState: viewModel.imageState,
                         style: style)
                .frame(width: 100,
                       height: 100)
            
            HStack(spacing: 16) {
                
                Button(action: {
                    openCamera()
                }, label: {
                    Image(systemName: "camera")
                })
                .photoStyle(color: .accentColor)
                
                Button(action: {
                    openPhotos()
                }, label: {
                    Image(systemName: "photo.on.rectangle.angled")
                })
                .photoStyle(color: .accentColor)
                
                Button(action: {
                    openInitials()
                }, label: {
                    Image(systemName: "pencil")
                })
                .photoStyle(color: .accentColor)
            }
            .padding(16)
            .frame(maxHeight: 120)
            
            recentlyUsedView
            
            Spacer()
        }
        .photosPicker(isPresented: $isPhotosPickerPresented,
                      selection: $viewModel.imageSelection,
                      matching: .images)
        .sheet(isPresented: $isCameraPickerPresented, content: {
            CameraView(selectedImage: $viewModel.selectedCameraImage)
                .fixateMacOSFrame()
        })
        .sheet(isPresented: $isInitialsPickerPresented, content: {
            InitialsView($viewModel.initialsModel, style: style)
                .fixateMacOSFrame()

        })
        .fixateMacOSFrame()
    }
    
    private func openCamera() {
        PermissionHandler.handler.checkPermissionStatus(.camera, result: { result in
            
            guard result else {
                // redirect to settings
                return
            }

            isCameraPickerPresented = true
        })
    }
    
    private func openPhotos() {
        isPhotosPickerPresented = true
    }
    
    private func openInitials() {
        isInitialsPickerPresented = true
    }
}

#Preview {
    ImageSelectionView(.empty, imageStyle: .circular)
}
