//
//  LFPushViewController.h
//  LFRouter_Example
//
//  Created by 福有李 on 2018/6/26.
//  Copyright © 2018年 李福有. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFPushViewController : UIViewController

//不使用这两个参数,render函数不会自动设置值
@property (nonatomic,strong) NSString<LFRouterParamsRequired> *name;
@property (nonatomic,assign) NSNumber<LFRouterParamsOption> *sex;
@end
