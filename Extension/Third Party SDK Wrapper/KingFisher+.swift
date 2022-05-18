//
//  KingFisher+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/28.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
        if let  urlString = urlString {
            let url = URL(string: urlString)
            self.kf.setImage(with: url, placeholder: placeHolder)
        }
    }
}
