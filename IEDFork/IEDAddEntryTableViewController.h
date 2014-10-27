//
//  IEDAddEntryTableViewController.h
//  IEDFork
//
//  Created by Samuel Seng on 10/27/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEDDataModel.h"

@interface IEDAddEntryTableViewController : UITableViewController

@property (strong, nonatomic) IEDDataModel *dataModel;

@property (nonatomic) int resistance;
@property (nonatomic) int temperature;

@end
