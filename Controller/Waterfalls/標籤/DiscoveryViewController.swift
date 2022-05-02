//
//  DiscoveryViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import UIKit
import XLPagerTabStrip

class DiscoveryViewController: UIViewController {
//    var subPage: [String] = ["All", "#2019名店", "#2020名店", "#2021名店"]
    var commentData: [Comment] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
       
        
    }
    
    
}
extension DiscoveryViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("推薦", comment: "barTagString"))
    }
}
