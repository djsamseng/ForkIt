//
//  IEDFood.h
//  IEDFork
//
//  Created by Samuel Seng on 10/26/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IEDFoodAttribute;

@interface IEDFood : NSManagedObject

@property (nonatomic, strong) NSString * foodName;
@property (nonatomic) int order;
@property (nonatomic, retain) NSSet *attributeValues;
@end

@interface IEDFood (CoreDataGeneratedAccessors)

- (void)addAttributeValuesObject:(IEDFoodAttribute *)value;
- (void)removeAttributeValuesObject:(IEDFoodAttribute *)value;
- (void)addAttributeValues:(NSSet *)values;
- (void)removeAttributeValues:(NSSet *)values;

@end
