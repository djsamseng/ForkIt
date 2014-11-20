//
//  IEDBluetoothBLE.h
//  IEDFork
//
//  Created by Samuel Seng on 10/30/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLE.h"
#import "IEDProtocols.h"

@interface IEDBluetoothBLE : NSObject <BLEDelegate>
@property (nonatomic, weak) id <IEDBluetoothProtocols> delegate;
@property (readonly) BOOL isConnected;
- (void)connect;
@end
