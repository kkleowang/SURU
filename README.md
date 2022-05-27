
 ![](https://i.imgur.com/KCV4mnE.png)
<p align="left">
    <img src="https://img.shields.io/badge/platform-iOS-lightgray">
    <img src="https://img.shields.io/badge/release-v1.1.1-green">
    <img src="https://img.shields.io/badge/license-GNU%20GPLv3-blue">
</p>

# SURU - A food community made for ramen lovers.
SURU provides a smooth experience to explore ramen stores on the map. 

Users can interact with others and earn achievements by reporting queues or publishing review articles.

[![](https://i.imgur.com/NKyvGNy.png)](https://apps.apple.com/tw/app/id1619738650)

## Contents
* [Features](#Features)
* [Techniques](#Techniques)
* [Libraries](#Libraries)
* [Requirement](#Requirement)
* [Version](#Version)
* [Release Notes](#Release-Notes)
* [Contact](#Contact)
* [License](#License)

## Features
## Techniques
- Developed with **MVC** pattern to build organized code which could be maintained easily.
- Built interfaces both with **Xib** and **Programmatically Auto Layout**.
- Combined **Lottie** with **gesture recognizer** to make a slider with animation effect.
- Customized annotations to present image as placemarks, which glowed via **Core Animation** with  several colors when receiving user's queuing reports.
- Created button bar to paging several categories collection view selection via tap or - swipe gesture with animated indicator view.
- Used **Core Data** with the **Singleton** pattern to manage drafts.
- Worked with **Date** and **DateFormatter**, converted Firebase **Timestamp** into a specific format to  present or use as a condition of switch statement's body.
## Libraries
- [Firebase/Auth](https://firebase.google.com/docs/auth)
- [Firebase/Firestore](https://firebase.google.com/docs/firestore)
- [Firebase/Storage](https://firebase.google.com/docs/storage)
- [Firebase/Crashlytics](https://firebase.google.com/docs/crashlytics)
- [SwiftLint](https://github.com/realm/SwiftLint)
- [Kingfisher](https://github.com/onevcat/Kingfisher)
- [MJRefresh](https://github.com/onevcat/Kingfisher)
- [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
- [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
- [Lottie](https://github.com/airbnb/lottie-ios)
- [XLPagerTabStrip](https://github.com/xmartlabs/XLPagerTabStrip)
- [CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout)

## Requirement
- Xcode 13.0 or later
- iOS 13.0 or later
- Swift 5
## Version
1.1.1
## Release Notes
| Version | Date           | Notes                              |
| --------| --------       | --------                           |
| 1.1.1   | 2022.05.27     | Fix bugs & improve code quality.   |
| 1.1.0   | 2022.05.18     | Add response feature, fix bugs.    |
| 1.0.1   | 2022.05.12     | Released in App Store.             |
## Contact
Leo Wang｜andy860916@hotmail.com
## License

SURU is released under the GNU GPLv3 license. See [LICENSE](https://github.com/Leownag/SURU/blob/main/LICENSE.md) for details.
