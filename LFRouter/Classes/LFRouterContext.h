//
//  LFRouterContext.h
//  BluChat
//
//  Created by 福有李 on 2018/1/11.
//  Copyright © 2018年 李福有. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFRouterContextDelegate

-(void)contextFinish:(id)object error:(NSError *)error;

@end

@interface LFRouterContext : NSObject

//打开的时候，是不是需要动画
@property (nonatomic,readonly) BOOL isAnimated;
//当前的视图
@property (nonatomic,readonly) UIViewController *visualViewController;
//present视图栈
@property (nonatomic,readonly) NSArray <UIViewController *> *viewControllers;
//打开的参数
@property (nonatomic,readonly) NSDictionary *params;


-(void)finish;
-(void)failed:(NSError *)error;

//通过runtime把参数反射给指针;
-(NSError *)renderParams:(NSDictionary *)params toViewController:(UIViewController *)viewController;

+(instancetype)instanceWithParams:(NSDictionary *)params animated:(BOOL)animated withOwner:(id)owner;
@end
