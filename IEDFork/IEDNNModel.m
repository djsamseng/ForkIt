//
//  IEDNNModel.m
//  IEDFork
//
//  Created by Samuel Seng on 10/28/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "IEDNNModel.h"
#import "IEDFood.h"

@implementation IEDNNModel

- (id)initWithData:(IEDFood *)foodType :(int)distance {
    self = [super init];
    if (self) {
        self.foodType = foodType;
        self.distance = distance;
    }
    return self;
}

@end