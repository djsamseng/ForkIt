//
//  IEDCategoryViewController.h
//  Functional Flatware
//
//  Created by Samuel Seng on 11/15/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ApiAI/ApiAI.h>
#import <ApiAI/AIVoiceRequest.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface IEDCategoryViewController : UITableViewController

@property (nonatomic, strong) ApiAI *apiAI;
@property (nonatomic, strong) AIVoiceRequest *voiceRequest;

@end
