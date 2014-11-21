//
//  IEDCategoryTableViewController.h
//  Functional Flatware
//
//  Created by Samuel Seng on 11/15/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ApiAI/ApiAI.h>
#import <ApiAI/AIVoiceRequest.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/PocketsphinxController.h>

#import <OpenEars/AcousticModel.h>

#import <OpenEars/OpenEarsEventsObserver.h>


@interface IEDCategoryTableViewController : UITableViewController < OpenEarsEventsObserverDelegate>

@property (nonatomic, strong) ApiAI *apiAI;

@property (nonatomic, strong) AIVoiceRequest *voiceRequest;



@property (strong, nonatomic) FliteController *fliteController;

@property (strong, nonatomic) Slt *slt;



@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;



@property (strong, nonatomic) NSArray *selection;



@property (strong, nonatomic) NSString*choice;

@end
