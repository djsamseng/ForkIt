//
//  IEDProtocols.h
//  IEDFork
//
//  Created by Samuel Seng on 10/30/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IEDBluetoothProtocols <NSObject>

- (void)bluetoothConnectFinished: (BOOL)success;
- (void)dataReceived: (int)resistance : (int)temperature;

@end
