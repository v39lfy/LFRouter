# LFRouter

[![Version](https://img.shields.io/cocoapods/v/LFRouter.svg?style=flat)](https://cocoapods.org/pods/LFRouter)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


## Description
block化的路由组件，支持url路由到指定界面。
1. 可以使用path传参，使用【:变量名】来捕获参数。例如：http://app.pvp.run/:userId/profile  (捕获参数方式参考了HHRouter)。
2. 可以使用query传参。例如http://app.pvp.run/:userId/profile?sort=1。
3. 可以使用app原生来传参，参考Demo中的 
```ObjC
[Router open:RouterPush params:@{@"name":@"AAA"}];
```
4. 当三种传参方式重名时，优先使用的参数为path > query > app
5. 对应的Controller，需要外界传入参数时，需要声明LFRouterParamsRequired或者LFRouterParamsOption，如果声明为Required，则框架会自动检查该参数是否存在。不存在则有错误回调，或控制台打印警告。如不声明这个属性是参数，则框架不会自动填充。
6. 所有的路由模块的跳转逻辑由对应的block处理，可以自定义跳转逻辑。参考demo。

## 想法未实现
1. 插件系统，比如自定义一个登录插件。当路由框架启动该插件之后。插件会过滤出需要登录的路径，当对这些路径进行跳转时。如果未登录会打开登录页。或者密码隐私全局保护等。
2. 路由优先级和生命周期管理
## Example

To run the example project, clone the repo,open Example/LFRouterExample

## Requirements

## Installation
### CocoaPods
LFRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LFRouter' , :git =>'https://github.com/v39lfy/LFRouter.git'
```

### Carthage
```ruby
github "v39lfy/LFRouter"
```
## Author

lify, admin@onlywish.me

## License

LFRouter is available under the MIT license. See the LICENSE file for more info.
