//
//  LFViewController.m
//  LFRouter
//
//  Created by 李福有 on 06/26/2018.
//  Copyright (c) 2018 李福有. All rights reserved.
//

#import "LFViewController.h"

@interface LFViewController ()

@end

@implementation LFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tabbar2:(id)sender {
    [Router open:RouterTable params:nil];
}
- (IBAction)push:(id)sender {
    [Router open:RouterPush params:@{@"name":@"AAA"}];
}
- (IBAction)pushnop:(id)sender {
    [Router open:RouterPush params:nil];
    
    //注意控制台警告,可以使用下边的函数来补捉错误
//    [Router open:RouterPush params:nil animated:YES completion:^(NSError *error) {
//        assert(error != nil);
//    }];
}

- (IBAction)moal:(id)sender {
    [Router open:RouterPresent params:nil];
}


@end
