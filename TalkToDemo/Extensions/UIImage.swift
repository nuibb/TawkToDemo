//
//  UIImage.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 25/7/24.
//

import UIKit
import AVFoundation
import CoreImage

extension UIImage {
    var invertImage: UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        guard let filter = CIFilter(name: "CIColorInvert") else {
            return nil
        }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter.outputImage else {
            return nil
        }
        
        let context = CIContext()
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    /// Resize image while keeping the aspect ratio. Original image is not modified.
    func resize(_ width: Int, _ height: Int) -> UIImage {
        /// Keep aspect ratio
        let maxSize = CGSize(width: width, height: height)
        
        let availableRect = AVFoundation.AVMakeRect(
            aspectRatio: self.size,
            insideRect: .init(origin: .zero, size: maxSize)
        )
        let targetSize = availableRect.size
        
        /// Set scale of renderer so that 1pt == 1px
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        
        /// Resize the image
        let resized = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resized
    }
}
