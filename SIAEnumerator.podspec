#
# Be sure to run `pod lib lint SIAEnumerator.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SIAEnumerator"
  s.version          = "0.3.0"
  s.summary          = "SIAEnumerator is utility for enumerator."
  s.description      = <<-DESC
                       SIAEnumerator is utility for enumerator. You can code using ruby-like or swift-like methods.
                       DESC
  s.homepage         = "https://github.com/siagency/SIAEnumerator"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "SI Agency" => "support@si-agency.co.jp" }
  s.source           = { :git => "https://github.com/siagency/SIAEnumerator.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
