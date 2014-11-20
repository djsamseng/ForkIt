//
//  IEDDataModel.m
//  IEDFork
//
//  Created by Samuel Seng on 10/26/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "IEDDataModel.h"
#import "IEDNNModel.h"
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

- (void)loadJSONData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"food_data" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error == nil) {
        for (NSDictionary *foodData in results) {
            for (NSString *foodName in foodData) {
                IEDFood *newFood = [self createFood];
                newFood.foodName = foodName;
                [self saveChanges];
                for (NSDictionary *foodAttributes in foodData[foodName]) {
                    if ([foodAttributes objectForKey:@"resistivity"] != nil && [foodAttributes objectForKey:@"resistance"] != nil && [foodAttributes objectForKey:@"temperature"] != nil) {
                        IEDFoodAttribute *newAttribute = [self createAttribute:newFood];
                        newAttribute.resistivity = [(NSString *)foodAttributes[@"resistivity"] intValue];
                        newAttribute.resistance = [(NSString *)foodAttributes[@"resistance"] intValue];
                        newAttribute.temperature = [(NSString *)foodAttributes[@"temperature"] intValue];
                    }
                }
                [self saveChanges];
            }
        }
        [self loadAllItems];
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
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

- (NSString *)identifyFood:(int)resistance :(int)resistivity {
    NSMutableDictionary *propertyDistances = [[NSMutableDictionary alloc] init];
    for (IEDFood *food in self.allItems) {
        for (IEDFoodAttribute *attribute in food.attributeValues) {
            //int score = abs(attribute.resistance - resistance) + 3 * abs(attribute.resistivity - resistivity);
            int score = abs(attribute.resistance - resistance);
            double distance = score < 0.1 ? 1000.0 : 100.0 / score;
            if (score < 500) {
                if ([propertyDistances objectForKey:food.foodName] == nil) {
                    
                    IEDNNModel *NNModel = [[IEDNNModel alloc] initWithData:food :distance];
                    propertyDistances[food.foodName] = NNModel;
                } else {
                    ((IEDNNModel *)propertyDistances[food.foodName]).distance += distance;
                }
            }
        }
    }
    NSArray *sortedFoods = [[propertyDistances allValues] sortedArrayUsingComparator: ^(id obj1, id obj2) {
        IEDNNModel *left = (IEDNNModel *) obj1;
        IEDNNModel *right = (IEDNNModel *) obj2;
        if (left.distance > right.distance) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (left.distance < right.distance) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    if ([sortedFoods count] == 0) {
        return @"None found";
    } else {
        int k = ceil(sqrt([sortedFoods count]));
        NSLog(@"K = %d", k);
        double total_score = 0.0;
        for (int i = 0; i < k; i++) {
            IEDNNModel *model = [sortedFoods objectAtIndex:i];
            total_score += model.distance;
        }
        NSMutableString *result = [[NSMutableString alloc] init];
        for (int i = 0; i < k; i++) {
            IEDNNModel *model = [sortedFoods objectAtIndex:i];
            [result appendFormat:@"%@ %d%@\n", model.foodType.foodName, (int)(100.0 * model.distance / total_score), @"%"];
        }
        return result;
    }
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

@end
