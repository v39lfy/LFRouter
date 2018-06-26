//
//  LFTabBarViewController.m
//  LFRouter_Example
//
//  Created by 福有李 on 2018/6/26.
//  Copyright © 2018年 李福有. All rights reserved.
//

#import "LFTabBarViewController.h"

@interface LFTabBarViewController ()

@end

@implementation LFTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
//    NSInteger index = [tabBar.items indexOfObject:item];
//    
//    switch (index) {
//        case 0:
//            {
//                [Router open:RouterHome params:nil];
//            }
//            break;
//        case 1:{
//            [Router open:RouterTable params:nil];
//        }
//        default:
//            break;
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
