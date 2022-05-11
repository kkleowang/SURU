//
//  StoreTopView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/10.
//

import UIKit
import Kingfisher
protocol StoreTopViewDelegate: AnyObject {
    func didTapCollect(_ view: StoreTopView, storeID: String)
    func didTapCollectWhenNotLogin(_ view: StoreTopView)
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
        if isCollect {
            collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
        } else {
            collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
        }
        
    }
    @IBAction func tapCollectButton(_ sender: UIButton) {
        guard let storeID = storeID, let isLogin = isUserLogin, let isCollect = isUserCollected else { return }
        if isLogin {
            self.delegate?.didTapCollect(self, storeID: storeID)
            if isCollect {
                collectButton.setImage(UIImage(named: "collect.empty"), for: .normal)
            } else {
                collectButton.setImage(UIImage(named: "collect.fill"), for: .normal)
            }
        } else {
            self.delegate?.didTapCollectWhenNotLogin(self)
        }
        
    }
}
