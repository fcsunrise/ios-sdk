
Pod::Spec.new do |spec|

  spec.name               = "AtlasSDK"
  spec.version            = "0.0.1"
  spec.summary            = "AtlasSDK is a framework which provides Atlas payment services implementation to be used in mobile apps"

  spec.description        = "AtlasSDK is a framework which provides Atlas payment services implementation to be used in mobile apps"

  spec.homepage           = "https://docs.cityhub.com.ua/introduction.html"
  spec.license            = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Yelyzaveta" => "kartcevayelyzaveta@gmail.com" }
  spec.platform           = :ios, "13.0"
  spec.swift_version      = "5.0"
  spec.source             = { :git => 'https://github.com/fcsunrise/ios-sdk.git', :tag => spec.version.to_s }

  spec.source_files = "AtlasSDK/**/*.{swift}"
  spec.resource_bundles = {
    'AtlasSDK' => ['AtlasSDK/**/*.{storyboard}', 'AtlasSDK/UI/Xibs/*.{xib}', 'AtlasSDK/*.xcassets', 'AtlasSDK/Resources/Fonts/**/*.otf', 'AtlasSDK/Resources/Fonts/**/*.ttf']
  }
  
  spec.dependency 'Alamofire'
  spec.dependency 'QuickLayout'
  spec.dependency 'Marshal'
  spec.dependency 'Promises'

  spec.xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
