#
# Be sure to run `pod lib lint TPUIKit-Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TPUIKit-Swift'
  s.version          = '1.0.0'
  s.summary          = 'Swift版 UI组件库.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Topredator/TPUIKit-Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Topredator' => 'luyanggold@163.com' }
  s.source           = { :git => 'https://github.com/Topredator/TPUIKit-Swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  
  s.source_files = 'TPUIKit-Swift/Classes/**/*'
  
  # 图片资源
  s.resource_bundles = {
      'TPUIKitSwift'  => ['TPUIKit-Swift/Assets/*xcassets']
  }
  
  s.subspec 'Base' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/Base/**/*'
  end
  
  s.subspec 'Alert' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/Alert/**/*'
  end
  
  s.subspec 'Blank' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/Blank/**/*'
      ss.dependency 'TPUIKit-Swift/Base'
  end
  
  s.subspec 'MarginLabel' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/MarginLabel/**/*'
  end
  
  s.subspec 'Menu' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/Menu/**/*'
      ss.dependency 'TPUIKit-Swift/Base'
  end
  
  s.subspec 'Navigator' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/Navigator/**/*'
  end
  s.subspec 'SimBtn' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/SimBtn/**/*'
  end
  
  s.subspec 'Tabbar' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/Tabbar/**/*'
      ss.dependency 'TPUIKit-Swift/Base'
  end

  s.subspec 'PageControl' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/PageControl/**/*'
  end
  
  s.subspec 'Banner' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/Banner/**/*'
      ss.dependency 'TPUIKit-Swift/PageControl'
  end
  
  s.subspec 'Toast' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/Toast/**/*'
      ss.dependency 'MBProgressHUD'
      ss.dependency 'TPUIKit-Swift/Base'
  end
  
  s.subspec 'Refresh' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/Refresh/**/*'
      ss.dependency 'MJRefresh'
      ss.dependency 'TPUIKit-Swift/Base'
  end
  
  s.subspec 'BackgroundLineView' do |ss|
      ss.source_files = 'TPUIKit-Swift/Classes/BackgroundLineView/**/*'
  end
  
  s.dependency 'SnapKit'
  s.dependency 'TPFoundation-Swift'
  
  
end
