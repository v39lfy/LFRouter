//
//  LFRouter+Config.h
//  BluChat
//
//  Created by 福有李 on 2018/6/25.
//  Copyright © 2018年 李福有. All rights reserved.
//

#import "LFRouter.h"
#import "LFRouterContext.h"
//@class LFRouterContext;
typedef void(^LFRouterHandle)(LFRouterContext *context);

@interface LFRouter (Config)

-(void)addKeys:(NSArray<NSString *> *)keys command:(LFRouterHandle)handle;
@end
