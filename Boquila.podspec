#
# Be sure to run `pod lib lint Boquila.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Boquila'
  s.version          = '0.1.0'
  s.summary          = 'Small, consistent, flexible way to work with remote config.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  I love using remote configuration software in my mobile apps. They allow me to make changes to live apps instantly without having to submit my app to the app store. 

  While working with remote configuration in my apps, I have thought about some cool ideas for using remote config in my apps. Using JSON strings for remote config values and string replacements for dynamic values just to name a few. 
  
  Boquila is a project for lovers of remote configuration software. Boquila aims to...
  * **Be small.** Don't try to do everything including the kitchen sink. Try to be as minimal of a project as possible and allow the developer to opt-in to features they want. 
  * **Consistent experience.** No matter what remote config service that you use, the API remains the same. 
  * **Flexible.** Boquila is not opinionated. It does only what it needs to do and nothing more. 
                       DESC

  s.homepage         = 'https://github.com/levibostian/Boquila-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Levi Bostian' => 'levi.bostian@gmail.com' }
  s.source           = { :git => 'https://github.com/levibostian/Boquila-iOS.git', :tag => s.version.to_s }
  s.default_subspec = "Core"
  s.ios.deployment_target = '8.0'
  s.static_framework = true

  s.subspec "Core" do |ss|
    ss.source_files  = 'Boquila/Core/**/*'
    ss.framework  = "Foundation"
  end

  s.subspec "Firebase" do |ss|
    ss.source_files = "Boquila/Firebase/**/*"
    ss.dependency "Boquila/Core"
    
    ss.dependency 'Firebase/Analytics' # required by remote config
    ss.dependency 'Firebase/RemoteConfig'    
  end

  s.subspec "Testing" do |ss|
    ss.source_files = "Boquila/Testing/**/*"
    ss.dependency "Boquila/Core"
  end
  
  # s.resource_bundles = {
  #   'Boquila' => ['Boquila/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
