# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'VanityPass' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VanityPass
  pod 'Alamofire'
  pod 'ReachabilitySwift' 
  pod 'IQKeyboardManagerSwift' 
  pod 'SwiftyJSON'  
  pod 'LGSideMenuController'
  pod ‘MBProgressHUD’
  pod 'DropDown'  
  pod 'SDWebImage'
  pod 'PayPal-iOS-SDK'

  #Pod for Google Map
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'

  #Pods for ImagePicker
  pod 'YangMingShan'
  pod ‘ImageSlideshow/Alamofire’

  #Pods for Firebase
  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end

  target 'VanityPassTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'VanityPassUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
