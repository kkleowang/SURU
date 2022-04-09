source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'
use_frameworks!

target 'STYLiSH' do
  # your other pod
  # ...
  pod 'Kingfisher', '~> 7.0'
  pod 'MJRefresh' 
  pod 'Alamofire', '~> 5.5'
  pod 'IQKeyboardManagerSwift'
  pod 'Toast-Swift'
  pod 'FBSDKLoginKit'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end