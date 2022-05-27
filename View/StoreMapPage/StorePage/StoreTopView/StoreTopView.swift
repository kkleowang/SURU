//
//  StoreTopView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/10.
//

import Kingfisher
import UIKit
protocol StoreTopViewDelegate: AnyObject {
    func didtapCollectionButton(_ view: StoreTopView)
    func didtapUnCollectionButton(_ view: StoreTopView)
}

class StoreTopView: UIView {
    weak var delegate: StoreTopViewDelegate?
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var collectButton: UIButton!
    var storeID: String?
    var isUserCollected: Bool?
    func layOutView(store: Store, isCollect: Bool) {
        storeID = store.storeID
        isUserCollected = isCollect
        mainImage.layer.cornerRadius = mainImage.bounds.width / 2
        mainImage.layer.borderWidth = 1.0
        mainImage.layer.borderColor = UIColor.white.cgColor
        mainImage.contentMode = .scaleAspectFill
        mainImage.clipsToBounds = true

        mainImage.kf.setImage(with: URL(string: store.mainImage), placeholder: UIImage(named: "mainImage"))
        name.text = store.name

        if isCollect {
            collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
        } else {
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
        }
    }

    @IBAction func tapCollectButton(_: UIButton) {
        if collectButton.currentImage == UIImage(named: "collect.fill") {
            delegate?.didtapUnCollectionButton(self)
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
        } else {
            delegate?.didtapCollectionButton(self)
            collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
        }
    }
}
