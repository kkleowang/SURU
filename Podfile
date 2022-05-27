source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!

target 'SURU_Leo' do
  # your other pod
  # ... 
  
  pod 'SwiftLint'
  pod 'Kingfisher', '~> 7.0'
  pod 'MJRefresh'
  pod 'IQKeyboardManagerSwift'
  pod 'JGProgressHUD'
  pod 'lottie-ios'
  pod 'XLPagerTabStrip', '~> 9.0'
  pod 'CHTCollectionViewWaterfallLayout/Swift'

  pod 'Firebase'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Crashlytics'

target 'SURU_LeoTests' do
        inherit! :search_paths
       pod 'Firebase'
  end
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
