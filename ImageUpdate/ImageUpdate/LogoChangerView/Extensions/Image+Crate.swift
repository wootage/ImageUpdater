//
//  Image+Crate.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 01/11/2023.
//

import SwiftUI

extension Image {
    static func createImage(_ data: Data?, cropped: Bool = true) -> Image? {
        guard let data else { return nil }
        
        var image = UIImage(data: data)
        if cropped {
            image = image?.cropImageToSquare()
        }
        
        guard let image else { return nil }
        return Image(uiImage: image)
    }
}

extension UIImage {
    func cropImageToSquare() -> UIImage? {
        
        let min = min(size.width, size.height)
        
        let size = CGSize(width: min, height: min)
        
        guard let cgImage else { return nil }
        
        let refWidth : CGFloat = CGFloat(cgImage.width)
        let refHeight : CGFloat = CGFloat(cgImage.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: imageOrientation)
        }
        
        return nil
    }
}
