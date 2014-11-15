//
//  ViewController.h
//  IEDFork
//
//  Created by Samuel Seng on 10/23/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEDProtocols.h"


#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

#import <OpenEars/LanguageModelGenerator.h>


#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/AcousticModel.h>

#import <OpenEars/OpenEarsEventsObserver.h>

#import <ApiAI/ApiAI.h>

@interface ViewController : UIViewController < OpenEarsEventsObserverDelegate, IEDBluetoothProtocols>
    @property (strong, nonatomic) FliteController *fliteController;
    @property (strong, nonatomic) Slt *slt;
    @property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
    @property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;
    @property (nonatomic, strong) ApiAI *apiAI;
@end

