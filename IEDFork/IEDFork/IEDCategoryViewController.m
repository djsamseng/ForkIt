//
//  IEDCategoryViewController.m
//  Functional Flatware
//
//  Created by Samuel Seng on 11/15/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "IEDCategoryViewController.h"
#import <ApiAI/ApiAI.h>
#import <ApiAI/AIVoiceRequest.h>

@interface IEDCategoryViewController ()

@end

@implementation IEDCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AIVoiceRequest *request = (AIVoiceRequest *)[_apiAI requestWithType:AIRequestTypeVoice];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        // Handle success ...
    } failure:^(AIRequest *request, NSError *error) {
        // Handle error ...
    }];
    
    self.voiceRequest = request;
    [_apiAI enqueue:request];
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
