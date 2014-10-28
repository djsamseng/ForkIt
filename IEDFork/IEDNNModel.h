//
//  IEDNNModel.h
//  IEDFork
//
//  Created by Samuel Seng on 10/28/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEDFood.h"

@interface IEDNNModel : NSObject

@property (strong, nonatomic) IEDFood *foodType;
@property (nonatomic) int distance;

- (id)initWithData:(IEDFood *)foodType :(int) distance;

@end
