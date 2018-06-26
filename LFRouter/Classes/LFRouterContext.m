//
//  LFRouterContext.m
//  BluChat
//
//  Created by 福有李 on 2018/1/11.
//  Copyright © 2018年 Bluchat. All rights reserved.
//

#import "LFRouterContext.h"
#import "objc/runtime.h"

@interface LFRouterContextProperty : NSObject
@property (nonatomic,strong) NSString *attributesName;
@property (nonatomic,assign) BOOL isOption;
@end

@implementation LFRouterContextProperty
@end

@interface LFRouterContext (){
    UIViewController *_visualViewController;
    NSArray <UIViewController *>* _stack;
}

//打开的时候，是不是需要动画
@property (nonatomic,readwrite) BOOL isAnimated;
//当前的视图
//@property (nonatomic,readonly) UIViewController *visualViewController;
//打开的参数
@property (nonatomic,readwrite) NSDictionary *params;

@property (nonatomic,weak) NSObject<LFRouterContextDelegate> *delegate;

@end

@implementation LFRouterContext

-(void)finish{
    if ([self.delegate respondsToSelector:@selector(contextFinish:error:)]) {
        [self.delegate contextFinish:self error:nil];
    }
}

-(void)failed:(NSError *)error{
    
    if (error == nil) {
        error = [NSError errorWithDomain:@"run.pvp.error.no" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"不知道发生了什么，该模块没有返回错误"}];
    }
    if ([self.delegate respondsToSelector:@selector(contextFinish:error:)]) {
        [self.delegate contextFinish:self error:error];
    }
}

-(NSError *)renderParams:(NSDictionary *)params toViewController:(UIViewController *)viewController{
    
    NSArray <LFRouterContextProperty *>*requirePropertys = [self getRequirePropertyFromObject:viewController];
    
    NSMutableArray *lackPropertys = @[].mutableCopy;
    
    for (LFRouterContextProperty *key in requirePropertys) {
        if (params[key] == nil && key.isOption == NO) {
            [lackPropertys addObject:key];
        }
    }
    
    if (lackPropertys.count != 0) {
        return [NSError errorWithDomain:@"run.pvp.error.params" code:-2 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"缺少%@参数",[lackPropertys componentsJoinedByString:@"、"]]}];
    }
    
    for (LFRouterContextProperty *key in requirePropertys) {
        
        NSObject *value = params[key.attributesName];
        if (value != nil) {
            [viewController setValue:value forKey:key.attributesName];
        }
        
    }
    
    return nil;
//    NSLog(@".. %@",requireProtocols);
}

-(NSArray <LFRouterContextProperty *> *)getRequirePropertyFromObject:(NSObject *)obj{
    NSMutableArray *requireProtocols = [NSMutableArray array];
    
    //自动设置参数
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList([obj class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertys[i];
        //get property attributes
        const char *attrs = property_getAttributes(property);
        NSString* propertyAttributes = @(attrs);
        NSArray* attributeItems = [propertyAttributes componentsSeparatedByString:@","];
        
        //ignore read-only properties
        if ([attributeItems containsObject:@"R"]) {
            continue; //to next property
        }
        
        NSArray *procols = [self getProtocolFromString:propertyAttributes];
        if([procols containsObject:@"LFRouterParamsRequired"]){
            LFRouterContextProperty *pm = [LFRouterContextProperty new];
            pm.attributesName = @(property_getName(property));
            pm.isOption = NO;
            [requireProtocols addObject:pm];
//            [requireProtocols addObject:@(property_getName(property))];
        }else if([procols containsObject:@"LFRouterParamsOption"]){
            LFRouterContextProperty *pm = [LFRouterContextProperty new];
            pm.attributesName = @(property_getName(property));
            pm.isOption = YES;
            [requireProtocols addObject:pm];
        };
    }
    free(propertys);
    return requireProtocols;
}

-(NSArray <NSString *> *)getProtocolFromString:(NSString *)s{
    NSString *protocolRegex = @"<[^>]+>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:protocolRegex options:0 error:nil];
    NSArray<NSTextCheckingResult *> * ranges =[regex matchesInString:s options:NSMatchingReportCompletion range:NSMakeRange(0, s.length)];
//    rangeOfFirstMatchInString:s options:0 range:NSMakeRange(0, s.length)
    if (ranges.count == 0) {
        return nil;
    }
    
    NSMutableArray *protocols = [NSMutableArray array];
    for (NSTextCheckingResult *result in ranges) {
        NSRange range = result.range;
        if (range.location != NSNotFound) {
            NSString *protocolString = [s substringWithRange:range];
            protocolString = [protocolString substringWithRange:NSMakeRange(1, protocolString.length-2)];
            [protocols addObject:protocolString];
        }
    }
    
    return protocols;
    
}

+(instancetype)instanceWithParams:(NSDictionary *)params animated:(BOOL)animated withOwner:(id)owner{
    LFRouterContext *context = [[self alloc] init];
    context.isAnimated = animated;
    context.params = params;
    context.delegate = owner;
    return context;
}

-(UIViewController *)visualViewController{
    if (_visualViewController == nil) {
        @synchronized(self){
            if (_visualViewController == nil) {
                //查找当前的Controller
                NSMutableArray *stack = [NSMutableArray array];
                UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                while (vc.presentedViewController != nil) {
                    [stack addObject:vc];
                    vc = vc.presentedViewController;
                }
                [stack addObject:vc];
                _stack = stack;
                _visualViewController = vc;
                
                if ([_visualViewController isKindOfClass:[UINavigationController class]]) {
                    _visualViewController = ((UINavigationController *)_visualViewController).visibleViewController;
                }
                
            }
        }
    }
    return _visualViewController;
}

-(NSArray<UIViewController *> *)viewControllers{
    if (_stack == nil) {
        [self visualViewController];
    }
    return  _stack;
}
@end
