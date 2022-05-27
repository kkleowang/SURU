//
//  FollowViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import UIKit
import XLPagerTabStrip

class FollowViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var commentData: [Comment] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension FollowViewController: IndicatorInfoProvider {
    func indicatorInfo(for _: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("追蹤中", comment: "barTagString"))
    }
}
