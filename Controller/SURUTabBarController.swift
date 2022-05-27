//
//  SURUTabBarController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit

private enum StoryboardCategory {
    static let storeMap = "StoreMapViewController"

    static let commentWall = "CommentWallViewController"

    static let comment = "CommentViewController"

    static let profile = "ProfileViewController"
}

private enum Tab {
    case commentWall

    case storeMap

    case publishComment

    case profile

    func controller() -> UIViewController {
        var controller: UIViewController
        let storyboard = UIStoryboard.main

        switch self {
        case .commentWall: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.commentWall)

        case .storeMap: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.storeMap)

        case .publishComment: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.comment)

        case .profile: controller = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.profile)
        }

        controller.tabBarItem = tabBarItem()
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return controller
    }

    func tabBarItem() -> UITabBarItem {
        switch self {
        case .storeMap:
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
                title: "發表食記",
                image: UIImage(systemName: "rectangle.stack.badge.plus"),
                selectedImage: UIImage(systemName: "rectangle.stack.badge.plus")
            )

        case .profile:
            return UITabBarItem(
                title: "我的",
                image: UIImage(systemName: "person.crop.circle"),
                selectedImage: UIImage(systemName: "person.crop.circle.fill")
            )
        }
    }
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private let tabs: [Tab] = [.storeMap, .commentWall, .publishComment, .profile]
    
    var draftTabBarItem: UITabBarItem!
    var orderObserver: NSKeyValueObservation!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .C4
        tabBar.backgroundColor = .white
        viewControllers = tabs.map { $0.controller() }
        delegate = self
        draftTabBarItem = viewControllers?[2].tabBarItem

        draftTabBarItem.badgeColor = .C4
        orderObserver = StorageManager.shared.observe(
            \StorageManager.comments,
            options: .new,
            changeHandler: { [weak self] _, change in

                guard let newValue = change.newValue else { return }

                if !newValue.isEmpty {

                    self?.draftTabBarItem.badgeValue = String(newValue.count)

                } else {

                    self?.draftTabBarItem.badgeValue = nil
                }
            }
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let currentUserID = UserRequestProvider.shared.currentUserID {
            AccountRequestProvider.shared.addLoginHistroy(date: Date(), currentUserID: currentUserID)
        } else {
            presentWelcomePage()
        }
    }

    func presentWelcomePage() {
        guard let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else { return }
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    func tabBarController(_: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
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
    func didSelectLookAround(_: SignInAndOutViewController) {
        selectedIndex = 0
    }

    func didSelectGoEditProfile(_: SignInAndOutViewController) {
        selectedIndex = 3
    }
}
