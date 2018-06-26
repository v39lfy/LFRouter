//
//  LFPushViewController.m
//  LFRouter_Example
//
//  Created by 福有李 on 2018/6/26.
//  Copyright © 2018年 李福有. All rights reserved.
//

#import "LFPushViewController.h"

@interface LFPushViewController ()

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@end

@implementation LFPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.name;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
