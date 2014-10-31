//
//  IEDDataModel.m
//  IEDFork
//
//  Created by Samuel Seng on 10/26/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "IEDDataModel.h"
@import CoreData;

@interface IEDDataModel ()
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@end
@implementation IEDDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString *path = [self itemArchivePath];
        NSURL *storeUrl = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}

- (BOOL)saveChanges
{
    NSError * error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}
- (BOOL)foodExists:(NSString *)foodName {
    for (IEDFood *food in self.allItems) {
        if ([food.foodName isEqualToString:foodName]) {
            return true;
        }
    }
    return false;
}

- (void)loadAllItems
{
    if (!self.allItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"IEDFood" inManagedObjectContext:self.context];
        request.entity = e;
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
        request.sortDescriptors = @[sd];
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        self.allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (IEDFood *)createFood
{
    int order;
    if ([self.allItems count] == 0) {
        order = 1;
    } else {
        order = [[self.allItems lastObject] order] + 1;
    }
    NSLog(@"Adding item with order %d", order);
    IEDFood *newFood = [NSEntityDescription insertNewObjectForEntityForName:@"IEDFood" inManagedObjectContext:self.context];
    newFood.order = order;
    [self.allItems addObject:newFood];
    return newFood;
}

- (IEDFoodAttribute *)createAttribute:(IEDFood *)foodType {
    IEDFoodAttribute *attribute = [NSEntityDescription insertNewObjectForEntityForName:@"IEDFoodAttribute" inManagedObjectContext:self.context];
    [foodType addAttributeValuesObject:attribute];
    return attribute;
}

- (void)removeFood:(IEDFood *)foodType
{
    [self.context deleteObject:foodType];
    [self.allItems removeObjectIdenticalTo:foodType];
}

- (NSString *)identifyFood:(int)resistance {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    for (IEDFood *f in self.allItems) {
        for (IEDFoodAttribute *a in f.attributeValues) {
            if (abs(a.resistance - resistance) < 500) {
                if ([attributes objectForKey:f.foodName] == nil) {
                    [attributes setObject:[NSNumber numberWithInt:1] forKey:f.foodName];
                } else {
                    int count = [attributes[f.foodName] intValue];
                    attributes[f.foodName] = [NSNumber numberWithInt:count + 1];
                }
            }
        }
    }
    if ([attributes count] == 0) {
        return @"None found within 200";
    } else {
        NSArray *sortedFoods = [attributes keysSortedByValueUsingComparator:^(id obj1, id obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        if ([sortedFoods count] == 1) {
            return [sortedFoods objectAtIndex:0];
        } else if ([sortedFoods count] == 2) {
            NSString *food0 = [sortedFoods objectAtIndex:0];
            NSString *food1 = [sortedFoods objectAtIndex:1];
            if ([attributes[food0] intValue] > [attributes[food1] intValue]) {
                return [sortedFoods objectAtIndex:0];
            } else {
                return @"Unable to determine";
            }
        } else {
            NSString *food0 = [sortedFoods objectAtIndex:0];
            NSString *food1 = [sortedFoods objectAtIndex:1];
            NSString *food2 = [sortedFoods objectAtIndex:2];
            if ([attributes[food0] intValue] > [attributes[food1] intValue] + [attributes[food2] intValue]) {
                return [sortedFoods objectAtIndex:0];
            } else {
                return @"Unable to determine";
            }
        }
    }
    return @"Error";
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

@end
