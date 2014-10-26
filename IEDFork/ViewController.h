//
//  ViewController.h
//  IEDFork
//
//  Created by Samuel Seng on 10/23/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"


#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

#import <OpenEars/LanguageModelGenerator.h>


#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/AcousticModel.h>

#import <OpenEars/OpenEarsEventsObserver.h>

@interface ViewController : UIViewController <BLEDelegate, OpenEarsEventsObserverDelegate>     @property (strong, nonatomic) FliteController *fliteController;
    @property (strong, nonatomic) Slt *slt;
    @property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
    @property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;
@end

