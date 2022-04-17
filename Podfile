source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!

target 'SURU_Leo' do
  # your other pod
  # ...
  pod 'Kingfisher', '~> 7.0'
  pod 'MJRefresh'
  pod 'Alamofire', '~> 5.5'
  pod 'IQKeyboardManagerSwift'
  pod 'Toast-Swift'
  pod 'lottie-ios'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'SwiftLint'
  pod 'SDWebImage', '~> 5.0'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
