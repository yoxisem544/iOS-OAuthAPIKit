#
# Be sure to run `pod lib lint APIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'APIKit'
  s.version          = '0.1.0'
  s.summary          = 'An Elegant OAuth RESTful API framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Help you to handle network calls and oauth refresh token.
  You do not need to know the complex part of oauth.
                       DESC

  s.homepage         = 'https://github.com/yoxisem544/APIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yoxisem544' => 'yoxisem544@gmail.com' }
  s.source           = { :git => 'https://github.com/yoxisem544/APIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.default_subspec = "Core"
  s.swift_version = '5.0'
  s.cocoapods_version = '>= 1.4.0'
  s.ios.deployment_target = '10.0'
  
  # s.resource_bundles = {
  #   'APIKit' => ['APIKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.subspec "Core" do |ss|
    ss.framework  = "Foundation"
    ss.source_files  = "APIKit/Classes/Core/**/*"
    s.dependency 'Alamofire', '~> 4.9'
    s.dependency 'Moya', '~> 13.0'
    s.dependency 'ObjectMapper', '~> 3.5'
    s.dependency 'PromiseKit', '~> 6.12'
    s.dependency 'SwiftyJSON', '~> 5.0'
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "APIKit/Classes/RxSwiftExtensions/**/*"
    ss.dependency "APIKit/Core"
    ss.dependency "Moya/RxSwift"
  end
end
