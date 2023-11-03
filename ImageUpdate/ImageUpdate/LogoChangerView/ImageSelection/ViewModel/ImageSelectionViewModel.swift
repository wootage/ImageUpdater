//
//  ImageSelectionViewModel.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 26/10/2023.
//

import PhotosUI
import SwiftUI

extension ImageSelectionView {
    
    class ViewModel: ObservableObject {        
        
        @Published private(set) var imageState: ImageState = .empty {
            didSet {
                switch imageState {
                case .initials(_), .success(_, _):
                    recentlyUsed.insert(imageState)
                default: break
                }
            }
        }
        @Published private(set) var recentlyUsed: Set<ImageState> = []
        
        @Published var imageSelection: PhotosPickerItem? {
            didSet {
                guard let imageSelection else { 
                    imageState = .empty
                    return
                }
                
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            }
        }
        
        var selectedCameraImage: Image? {
            didSet {
                guard let selectedCameraImage else {
                    imageState = .empty
                    return
                }
                
                imageState = .success(selectedCameraImage, Date.now.timeIntervalSince1970)
            }
        }
        
        var initialsModel: InitialsModel {
            didSet {
                selectedCameraImage = nil
                imageState = .initials(initialsModel)
            }
        }
        
        init(_ image: Image? = nil,
             initialsModel: InitialsModel = InitialsModel()) {
            self.selectedCameraImage = image
            self.initialsModel = initialsModel
        }
        
        init(_ state: ImageState) {
            self.imageState = state

            switch state {
            case .success(let image, _):
                self.selectedCameraImage = image
                self.initialsModel = InitialsModel()
            case .initials(let model):
                self.initialsModel = model
            default: self.initialsModel = InitialsModel()
            }
        }
        
        func updateImageState(_ newImageState: ImageState) {
            self.imageState = newImageState
        }
        
        // MARK: - Private - Misc.
        private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
            // Image.self loads the image in wrong orientation on macOS
            return imageSelection.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    guard imageSelection == self.imageSelection else { return }
                    
                    switch result {
                    case .success(let data):
                        guard let image = Image.createImage(data) else {
                            self.imageState = .empty
                            return
                        }
                        self.imageState = .success(image, Date.now.timeIntervalSince1970)
                    case .failure(let error):
                        self.imageState = .failure(error)
                    }
                }
            }
        }
    }
}
