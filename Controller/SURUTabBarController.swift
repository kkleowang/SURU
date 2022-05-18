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
    
    case waterfalls
    
    case mapping
    
    case comment
    
    case profile
    
    func controller() -> UIViewController {
        var controller: UIViewController
        let storyboard = UIStoryboard.main
        
        switch self {
        case .waterfalls: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.waterfalls)
            
        case .mapping: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.mapping)
            
        case .comment: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.comment)
            
        case .profile: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.profile)
        }
        
        controller.tabBarItem = tabBarItem()
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        switch self {
        case .waterfalls:
            return UITabBarItem(
                title: "探索",
                image: UIImage(systemName: "mosaic"),
                selectedImage: UIImage(systemName: "mosaic.fill")
            )
            
        case .mapping:
            return UITabBarItem(
                title: "地圖",
                image: UIImage(systemName: "location.circle"),
                selectedImage: UIImage(systemName: "location.circle.fill")
            )
            
        case .comment:
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

class SURUTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private let tabs: [Tab] = [.mapping, .waterfalls, .comment, .profile]
    var orderObserver: NSKeyValueObservation!
    var trolleyTabBarItem: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserRequestProvider.shared.listenFirebaseLogin { _ in
//        }
        
        self.tabBar.tintColor = .C4
        
        view.backgroundColor = .white
        viewControllers = tabs.map({ $0.controller() })
        delegate = self
        trolleyTabBarItem = viewControllers?[2].tabBarItem
        
        trolleyTabBarItem.badgeColor = .C4
        orderObserver = StorageManager.shared.observe(
            \StorageManager.comments,
            options: .new,
            changeHandler: { [weak self] _, change in
            
                guard let newValue = change.newValue else { return }
                
                if newValue.count > 0 {
                    
                    self?.trolleyTabBarItem.badgeValue = String(newValue.count)
                
                } else {
                
                    self?.trolleyTabBarItem.badgeValue = nil
                }
            }
        )
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = UserRequestProvider.shared.currentUser {
            AccountRequestProvider.shared.addLoginHistroy(date: Date(), currentUserID: user.uid)
            print("Logined , id: \(user.uid)")
        } else {
            print("Not login, presentWelcomPage")
            presentWelcomePage()
            
        }
    }
    private func showLoginAlert(type: Tab) {
        presentWelcomePage()
    }
    func presentWelcomePage() {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else { return }
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        if UserRequestProvider.shared.currentUser != nil {
            return true
        } else {
            switch viewController {
            case viewControllers?[0]:
                return true
            case viewControllers?[1]:
                presentWelcomePage()
//                showLoginAlert(type: .waterfalls)
                return false
            case viewControllers?[2]:
                presentWelcomePage()
//                showLoginAlert(type: .comment)
                return false
            case viewControllers?[3]:
                presentWelcomePage()
//                showLoginAlert(type: .profile)
                return false
            default:
                print("WrongInTarbar")
                return false
            }
            
        }
    }
    
}
extension SURUTabBarViewController: SignInAndOutViewControllerDelegate {
    func didSelectLookAround(_ view: SignInAndOutViewController) {
        selectedIndex = 0
    }
    
    func didSelectGoEditProfile(_ view: SignInAndOutViewController) {
        selectedIndex = 3
    }
}
