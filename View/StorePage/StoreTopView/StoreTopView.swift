//
//  StoreTopView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/10.
//

import UIKit
import Kingfisher
protocol StoreTopViewDelegate: AnyObject {
    func didtapCollectionButton(_ view: StoreTopView)
    func didtapUnCollectionButton(_ view: StoreTopView)
    func didtapWhenNotLogin(_ view: StoreTopView)
}
class StoreTopView: UIView {
    weak var delegate: StoreTopViewDelegate?
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var collectButton: UIButton!
    var storeID: String?
    var isUserLogin: Bool?
    var isUserCollected: Bool?
    func layOutView(store: Store, isCollect: Bool, isLogin: Bool) {
        isUserLogin = isLogin
        storeID = store.storeID
        isUserCollected = isCollect
        mainImage.layer.cornerRadius = mainImage.bounds.width / 2
        mainImage.layer.borderWidth = 1.0
        mainImage.layer.borderColor = UIColor.white.cgColor
        mainImage.contentMode = .scaleAspectFill
        mainImage.clipsToBounds = true
        
        mainImage.kf.setImage(with: URL(string: store.mainImage), placeholder: UIImage(named: "AppIcon"))
        name.text = store.name
        if isLogin {
            if isCollect {
                collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
            } else {
                collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
            }
        } else {
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
        }
        
        
    }
    @IBAction func tapCollectButton(_ sender: UIButton) {
        
        
        if UserRequestProvider.shared.currentUser != nil {
            if collectButton.currentImage == UIImage(named: "collect.fill") {
                self.delegate?.didtapUnCollectionButton(self)
                collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
            } else {
                self.delegate?.didtapCollectionButton(self)
                collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
            }
        } else {
            self.delegate?.didtapWhenNotLogin(self)
        }
    }
}
