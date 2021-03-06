//
//  IEDDataModel.h
//  IEDFork
//
//  Created by Samuel Seng on 10/26/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEDFood.h"
#import "IEDFoodAttribute.h"


@interface IEDDataModel : NSObject

@property (strong, nonatomic) NSMutableArray *allItems;
@property (strong, nonatomic) NSString *validCategory;

- (BOOL)saveChanges;
- (IEDFood *)createFood;
- (void)loadJSONData;
- (void)checkForUpdatedData;
- (IEDFoodAttribute *)createAttribute:(IEDFood *)foodType;
- (BOOL)foodExists:(NSString *)foodName;
- (NSString *)identifyFood:(int)resistance : (int)resistivity;

@end
