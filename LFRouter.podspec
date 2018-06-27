#
# Be sure to run `pod lib lint LFRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LFRouter'
  s.version          = '0.1.1'
  s.summary          = 'LFRouter 用于：\n\t1.解耦ViewController之间的调用 \n\t2.统一h5和view之间的跳转逻辑 \n\t3.插件化viewController进入之前的逻辑（比如：某些界面需要登录等等）'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  LFRouter的主要功能有:
  1.添加路由跳转。（支持url path传参，query传参，本地手动传参）
  2.缺少参数自动检测
  2.添加界面的前置逻辑，比如:
    1)某个用户详情页面需要一个UserModel来展示，本地打开个人中心界面都会由上一个界面传过来一个UserModel.
      现在需要h5打开app来跳转用户详情，只传过来一个userid,你可以在这个路由下前置请求网络；
  3.统一管理controller生命周期，所有的跳转都以队列任务的方式保存，你可以设置规则及优先级。
                       DESC

  s.homepage         = 'https://github.com/v39lfy/LFRouter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'v39lfy' => 'admin@onlywish.me' }
  s.source           = { :git => 'https://github.com/v39lfy/LFRouter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LFRouter/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LFRouter' => ['LFRouter/Assets/*.png']
  # }

   s.public_header_files = 'LFRouter/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
