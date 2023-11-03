//
//  CameraModel.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 31/10/2023.
//

import AVFoundation
import SwiftUI

class CameraModel: ObservableObject {
    
    private var session = AVCaptureSession()
    
    private var deviceInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?
    
    private let captureProcessor = PhotoCaptureProcessor()
    
    private var device: AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) ?? AVCaptureDevice.default(for: .video)
    }
    
    lazy var cameraPreviewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }()
    
    @Published var image: Image?
    
    func setup() {
        
        guard let device else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
  
        guard session.canAddInput(input) else { return }
        
        let toRemove = session.outputs.filter({
            $0 is AVCapturePhotoOutput
        })
        
        toRemove.forEach({ session.removeOutput($0) })
        
        let photoOutput = AVCapturePhotoOutput()
        
        guard session.canAddOutput(photoOutput) else { return }
        
        session.addInput(input)
        session.addOutput(photoOutput)
        
        self.deviceInput = input
        self.photoOutput = photoOutput
        
        photoOutput.maxPhotoQualityPrioritization = .quality
        
        setupProcessing()
        
        start()
    }
    
    private func setupProcessing() {
        captureProcessor.didFinishProcessing = { [weak self] photo, error in
            guard let self else { return }
            self.image = Image.createImage(photo.fileDataRepresentation())
        }
        
        captureProcessor.willBeginCapture = {
            // TODO: 
        }
    }
    
    private func start() {
        DispatchQueue.global().async {
            self.session.startRunning()
        }
    }
    
    func stop() {
        DispatchQueue.global().async {
            self.session.stopRunning()
        }
    }
    
    func retake() {
        image = nil
    }
    
    func captureImage() {
        
        let settings = AVCapturePhotoSettings()        
        photoOutput?.capturePhoto(with: settings, delegate: captureProcessor)
    }
}

// MARK: - PhotoCaptureProcessor - AVCapturePhotoCapture - Delegate
fileprivate class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {

    var willBeginCapture: (() -> ())?
    var didFinishProcessing: ((AVCapturePhoto, Error?) -> ())?
    
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        willBeginCapture?()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        didFinishProcessing?(photo, error)
    }
}
