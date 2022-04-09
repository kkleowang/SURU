source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
use_frameworks!

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
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
