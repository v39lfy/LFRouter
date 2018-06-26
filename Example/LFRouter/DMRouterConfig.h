//
//  DMRouterConfig.h
//  LFRouter_Example
//
//  Created by 福有李 on 2018/6/26.
//  Copyright © 2018年 李福有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LFRouter/LFRouter.h>

extern NSString *RouterHome;
extern NSString *RouterTable;
extern NSString *RouterPush;
extern NSString *RouterPresent;

#define Router [LFRouter instance]

@interface DMRouterConfig : NSObject

+(void)config;

@end
