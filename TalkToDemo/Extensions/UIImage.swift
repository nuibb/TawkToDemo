//
//  UIImage.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 25/7/24.
//

import UIKit
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
}
