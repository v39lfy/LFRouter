//
//  LFRouter.h
//  BluChat
//
//  Created by 福有李 on 2018/1/11.
//  Copyright © 2018年 李福有. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LFRouterParamsRequired
@end
@protocol LFRouterParamsOption
@end

typedef void(^LFRouterCompletion)(NSError *error);

@interface LFRouter : NSObject

+(instancetype)instance;
//如果url和params出现了相同的参数，以url解析出来的参数为准
//url里边的解析规则路径 > query， 路径跟query出现一样的参数，会优先使用路径的
-(void)open:(NSString const*)url params:(NSDictionary *)params animated:(BOOL)animated completion:(LFRouterCompletion)completion;

-(void)open:(NSString const*)url params:(NSDictionary *)params;

@end
