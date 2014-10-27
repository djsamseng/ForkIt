//
//  IEDFoodAttribute.h
//  IEDFork
//
//  Created by Samuel Seng on 10/26/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IEDFood;

@interface IEDFoodAttribute : NSManagedObject

@property (nonatomic) int resistance;
@property (nonatomic) int temperature;
@property (nonatomic, strong) IEDFood *relationship;

@end
