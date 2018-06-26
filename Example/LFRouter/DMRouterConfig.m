//
//  DMRouterConfig.m
//  LFRouter_Example
//
//  Created by 福有李 on 2018/6/26.
//  Copyright © 2018年 李福有. All rights reserved.
//

#import "DMRouterConfig.h"

#import <LFRouter/LFRouter+Config.h>

 NSString *RouterHome = @"1";
 NSString *RouterTable = @"2";
 NSString *RouterPush = @"3";
 NSString *RouterPresent = @"4";
@implementation DMRouterConfig

+(void)config{
    [Router addKeys:@[RouterHome] command:^(LFRouterContext *context) {
        UITabBarController *tabbar = ( UITabBarController *)context.viewControllers[0];
        [tabbar setSelectedIndex:0];
        [context finish];
    }];
    
    [Router addKeys:@[RouterTable] command:^(LFRouterContext *context) {
        UITabBarController *tabbar = ( UITabBarController *)context.viewControllers[0];
        [tabbar setSelectedIndex:1];
        [context finish];
    }];
    
    [Router addKeys:@[RouterPush] command:^(LFRouterContext *context) {
        UITabBarController *tabbar = ( UITabBarController *)context.viewControllers[0];
        UINavigationController *nav = tabbar.viewControllers[tabbar.selectedIndex];
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"push"];
        NSError *error = [context renderParams:context.params toViewController:vc];
        if (error != nil) {
            [context failed:error];
            return ;
        }
        [nav pushViewController:vc animated:YES];
        [context finish];
    }];
    
    [Router addKeys:@[RouterPresent] command:^(LFRouterContext *context) {

        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"present"];
        NSError *error = [context renderParams:context.params toViewController:vc];
        
        if (error != nil) {
            [context failed:error];
            return ;
        }
        [context.visualViewController presentViewController:vc animated:context.isAnimated completion:^{
            [context finish];
        }];
    }];
}
@end
