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

- (BOOL)saveChanges;
- (IEDFood *)createFood;

@end
