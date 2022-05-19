//
//  CommentWallViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import UIKit
import XLPagerTabStrip


class CommentWallViewController: ButtonBarPagerTabStripViewController {
    override func viewDidLoad() {
        settings.style.selectedBarBackgroundColor = UIColor.C4 ?? UIColor.systemOrange
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0
        super.viewDidLoad()
        
        self.navigationItem.title = "探索食記"
        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _: CGFloat, changeCurrentIndex: Bool, _: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard.main
        guard let discoveryVC = storyboard.instantiateViewController(identifier: "WaterfallViewController") as? WaterfallViewController else { return [] }
        discoveryVC.pageStatus = .discovery
        guard let followedVC = storyboard.instantiateViewController(identifier: "WaterfallViewController") as? WaterfallViewController else { return [] }
        followedVC.pageStatus = .follow
        guard let collectedVC = storyboard.instantiateViewController(identifier: "WaterfallViewController") as? WaterfallViewController else { return [] }
        collectedVC.pageStatus = .collect
        
        return [discoveryVC, followedVC, collectedVC]
    }
}
