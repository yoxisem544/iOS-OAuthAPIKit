#
# Be sure to run `pod lib lint OAuthAPIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OAuthAPIKit'
  s.version          = '3.2.2'
  s.summary          = 'An Elegant OAuth RESTful API framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A network abstraction layer that help you to create a type safe network layer.
  With help of Promise and RxSwift to easy handle complex callback and streaming problem.
  ObjectMapper to help decode JSON to Swift object.
  Also, most complex part of OAuth 2.0 is access and refresh token. We've create a easy way for you to manage tokens. This include token refresh, request retry, retry with exponetial behavior and suspending on going requests.
                       DESC

  s.homepage         = 'https://github.com/yoxisem544/iOS-OAuthAPIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yoxisem544' => 'yoxisem544@gmail.com' }
  s.source           = { :git => 'https://github.com/yoxisem544/iOS-OAuthAPIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.default_subspec = "Core"
  s.swift_version = '5.0'
  s.cocoapods_version = '>= 1.4.0'
  s.ios.deployment_target = '10.0'
  s.module_name = 'APIKit'

  s.subspec "Core" do |ss|
    ss.framework  = "Foundation"
    ss.source_files  = "OAuthAPIKit/Classes/Core/**/*"
    s.dependency 'Alamofire', '~> 4.9'
    s.dependency 'Moya', '~> 13.0'
    s.dependency 'ObjectMapper', '~> 3.5'
    s.dependency 'PromiseKit', '~> 6.12'
    s.dependency 'SwiftyJSON', '~> 5.0'
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "OAuthAPIKit/Classes/RxSwiftExtensions/**/*"
    ss.dependency "OAuthAPIKit/Core"
    ss.dependency "Moya/RxSwift"
  end
end
