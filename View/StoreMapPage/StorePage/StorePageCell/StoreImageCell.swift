//
//  StoreImageCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import Kingfisher
import UIKit

protocol StoreImageCellDelegate: AnyObject {
    func didTapPopularImage(_ view: StoreImageCell, image: UIImage)
    func didTapmenuImage(_ view: StoreImageCell, image: UIImage)
    func didTapmoreImage(_ view: StoreImageCell, image: UIImage)
}

class StoreImageCell: UITableViewCell {
    weak var delegate: StoreImageCellDelegate?
    @IBOutlet var popularImageView: UIImageView!
    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var moreImageView: UIImageView!
    @IBOutlet var moreBlurView: UIView!

    func layoutCell(mostLikeImage: [String]) {
        selectionStyle = .none

        popularImageView.loadImage(mostLikeImage[0], placeHolder: UIImage.asset(.noData))
        menuImageView.loadImage(mostLikeImage[1], placeHolder: UIImage.asset(.noData))
        moreImageView.loadImage(mostLikeImage[2], placeHolder: UIImage.asset(.noData))
        let tapPopular = UITapGestureRecognizer(target: self, action: #selector(didTapPopularImage))
        let tapMenu = UITapGestureRecognizer(target: self, action: #selector(didTapmenuImage))
        let tapMore = UITapGestureRecognizer(target: self, action: #selector(didTapmoreImage))

        popularImageView.addGestureRecognizer(tapPopular)
        menuImageView.addGestureRecognizer(tapMenu)
        moreBlurView.addGestureRecognizer(tapMore)

        popularImageView.isUserInteractionEnabled = true
        menuImageView.isUserInteractionEnabled = true
        moreImageView.isUserInteractionEnabled = true

        popularImageView.cornerRadii(radii: 10)
        menuImageView.cornerRadii(radii: 10)
        moreImageView.cornerRadii(radii: 10)
    }

    @objc func didTapPopularImage() {
        guard let image = popularImageView.image else { return }
        delegate?.didTapPopularImage(self, image: image)
    }

    @objc func didTapmenuImage() {
        guard let image = menuImageView.image else { return }
        delegate?.didTapmenuImage(self, image: image)
    }

    @objc func didTapmoreImage() {
        guard let image = moreImageView.image else { return }
        delegate?.didTapmoreImage(self, image: image)
    }
}
