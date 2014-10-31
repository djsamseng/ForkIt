//
//  IEDMainViewController.m
//  IEDFork
//
//  Created by Samuel Seng on 10/30/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "IEDMainViewController.h"
#import "ECSlidingSegue.h"
@interface IEDMainViewController ()

@end

@implementation IEDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ECSlidingSegue *ss = (ECSlidingSegue *)segue;
    ss.skipSettingTopViewController = YES;
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
