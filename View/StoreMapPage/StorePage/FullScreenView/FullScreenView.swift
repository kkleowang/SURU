//
//  FullScreenView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/9.
//

import UIKit

class FullScreenView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    func layoutView(image: String) {
        imageView.loadImage(image, placeHolder: UIImage.asset(.mainImage))
    }
}
