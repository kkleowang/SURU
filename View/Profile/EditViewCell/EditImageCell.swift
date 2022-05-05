//
//  EditImageCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/5.
//

import UIKit
import Kingfisher

protocol EditImageCellDelegate: AnyObject {
    func didTapEditImage(_ view: EditImageCell)
}
class EditImageCell: UITableViewCell {
    weak var delegate: EditImageCellDelegate?
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var editImageButton: UIButton!
    @IBAction func tapEditImageButton(_ sender: UIButton) {
        self.delegate?.didTapEditImage(self)
    }
    
    func layoutCell(image: String) {
        mainImageView.kf.setImage(with: URL(string: image))
        mainImageView.layer.cornerRadius = 30
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        mainImageView.addGestureRecognizer(tap)
    }
    @objc func tapImage() {
        self.delegate?.didTapEditImage(self)
    }
}
