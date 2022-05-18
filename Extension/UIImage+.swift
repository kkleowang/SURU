//
//  UIImage+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import Foundation
import UIKit

enum ImageAsset: String {
    
    case mainImage
    case noData
}


// swiftlint:enable identifier_name

extension UIImage {
    static func asset(_ asset: ImageAsset) -> UIImage? {
        return UIImage(named: asset.rawValue)
    }
    
    func withSaturationAdjustment(byVal: CGFloat) -> UIImage {
        guard let cgImage = self.cgImage else { return self }
        guard let filter = CIFilter(name: "CIColorControls") else { return self }
        filter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
        filter.setValue(byVal, forKey: kCIInputSaturationKey)
        guard let result = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let newCgImage = CIContext(options: nil).createCGImage(result, from: result.extent) else { return self }
        return UIImage(cgImage: newCgImage, scale: UIScreen.main.scale, orientation: imageOrientation)
    }
}
