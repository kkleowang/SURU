//
//  SURUTabBarController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit
import Alamofire


private struct StoryboardCategory {
    static let waterfalls = "CommentWallViewController"
    
    static let mapping = "MappingViewController"
    
    static let comment = "CommentViewController"
    
    static let profile = "ProfileViewController"
}

private enum Tab {
    case commentWall
    
    case mapPage
    
    case publishComment
    
    case profile
    
    func controller() -> UIViewController {
        var controller: UIViewController
        let storyboard = UIStoryboard.main
        
        switch self {
        case .commentWall: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.waterfalls)
            
        case .mapPage: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.mapping)
            
        case .publishComment: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.comment)
            
        case .profile: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.profile)
        }
        
        controller.tabBarItem = tabBarItem()
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        switch self {
        case .mapPage:
            return UITabBarItem(
                title: "地圖",
                image: UIImage(systemName: "location.circle"),
                selectedImage: UIImage(systemName: "location.circle.fill")
            )
            
        case .commentWall:
            return UITabBarItem(
                title: "探索",
                image: UIImage(systemName: "mosaic"),
                selectedImage: UIImage(systemName: "mosaic.fill")
            )
            
        case .publishComment:
            return UITabBarItem(
                title: "發表評論",
                image: UIImage(systemName: "rectangle.stack.badge.plus"),
                selectedImage: UIImage(systemName: "rectangle.stack.badge.plus")
            )
            
        case .profile:
            return UITabBarItem(
                title: "個人資料",
                image: UIImage(systemName: "person.crop.circle"),
                selectedImage: UIImage(systemName: "person.crop.circle.fill")
            )
        }
    }
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private let tabs: [Tab] = [.mapPage, .commentWall, .publishComment, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        UserRequestProvider.shared.listenFirebaseLogin
        tabBar.tintColor = .C4
        view.backgroundColor = .white
        viewControllers = tabs.map { $0.controller() }
        delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                self.tabBar.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let currentUserID = UserRequestProvider.shared.currentUserID {
            AccountRequestProvider.shared.addLoginHistroy(date: Date(), currentUserID: currentUserID)
            print("Logined , id: \(currentUserID)")
        } else {
            print("Not login, presentWelcomPage")
            presentWelcomePage()
        }
    }
    func presentWelcomePage() {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else { return }
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if UserRequestProvider.shared.currentUser == nil {
            switch viewController {
            case viewControllers?[0]:
                return true
            default:
                presentWelcomePage()
                return false
            }
        } else {
            return true
        }
    }
}
extension TabBarViewController: SignInAndOutViewControllerDelegate {
    func didSelectLookAround(_ view: SignInAndOutViewController) {
        selectedIndex = 0
    }
    
    func didSelectGoEditProfile(_ view: SignInAndOutViewController) {
        selectedIndex = 3
    }
}
