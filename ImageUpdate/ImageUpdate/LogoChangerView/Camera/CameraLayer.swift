//
//  CameraLayer.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 26/10/2023.
//

import SwiftUI
import AVFoundation

class LayeredView: UIView {
    private var previewLayer: AVCaptureVideoPreviewLayer
    
    init(previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer = previewLayer
        super.init(frame: .zero)
        
        layer.addSublayer(previewLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
}

struct CameraLayer: UIViewRepresentable {
    
    var previewLayer: AVCaptureVideoPreviewLayer
    
    func makeUIView(context: Context) -> some UIView {
        let view = LayeredView(previewLayer: previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
