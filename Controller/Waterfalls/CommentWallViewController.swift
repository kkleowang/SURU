//
//  CommentWallViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/30.
//

import UIKit
import XLPagerTabStrip


class CommentWallViewController: ButtonBarPagerTabStripViewController {
    
    var accounts: [Account] = []
    var comments: [Comment] = []
    var stores: [Store] = []
    var currentAccount: Account?
    
    override func viewDidLoad() {

        settings.style.selectedBarBackgroundColor = .white
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0

        super.viewDidLoad()
        self.navigationItem.title = "探索食記"
         
        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
        

    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let discoveryVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController") as! DiscoveryViewController
        let disVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController") as! DiscoveryViewController
        let triVC = storyboard.instantiateViewController(identifier: "DiscoveryViewController") as! DiscoveryViewController
        
        
        return[discoveryVC, disVC, triVC]
    }
    
    
}
// firebase
extension CommentWallViewController {
    
    
}
