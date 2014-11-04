//
//  IEDBluetoothBLE.m
//  IEDFork
//
//  Created by Samuel Seng on 10/30/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "IEDBluetoothBLE.h"


@interface IEDBluetoothBLE()
@property (strong, nonatomic) BLE *bleShield;


@end

@implementation IEDBluetoothBLE

//Bluetooth initialization

- (id)init {
    self = [super init];
    if (self) {
        self.bleShield = [[BLE alloc] init];
        [self.bleShield controlSetup];
        self.bleShield.delegate = self;
    }
    return self;
}

#pragma mark - Bluetooth
- (void) connectionTimer:(NSTimer *)timer
{
    if (self.bleShield.peripherals.count > 0)
        {
        [self.bleShield connectPeripheral:[self.bleShield.peripherals objectAtIndex:0]];
        }
    else
        {
        
        }
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    int resistanceEnd = [s rangeOfString:@"R"].location;
    int resistance2End = [s rangeOfString:@"S"].location;
    int temperatureEnd = [s rangeOfString:@"T"].location;
    if (resistanceEnd < 10) {
        NSString *resistance = [s substringToIndex:resistanceEnd];
        [self.delegate dataReceived:[resistance intValue] :YES :NO :NO];
    } else if (resistance2End < 10) {
        NSString *resistance2 = [s substringToIndex:resistance2End];
        [self.delegate dataReceived:[resistance2 intValue] :NO :YES :NO];
    } else if (temperatureEnd < 10) {
        NSString *temperature = [s substringToIndex:temperatureEnd];
        [self.delegate dataReceived:[temperature intValue] :NO :NO :YES];
    }
}

NSTimer *rssiTimer;

- (void)readRSSITimer:(NSTimer *)timer
{
    [self.bleShield readRSSI];
}

- (void)bleDidDisconnect
{
    //[self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    [rssiTimer invalidate];
    [self.delegate bluetoothConnectFinished:NO];
}

-(void)bleDidConnect
{
    //[self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
    [self.delegate bluetoothConnectFinished:YES];
}

-(void)bleDidUpdateRSSI:(NSNumber *)rssi {
}

- (void)connect {
    if (self.bleShield.activePeripheral)
        {
        if (self.bleShield.activePeripheral.state == CBPeripheralStateConnected)
            {
            [[self.bleShield CM] cancelPeripheralConnection:[self.bleShield activePeripheral]];
            return;
            }
        }
    if (self.bleShield.peripherals) {
        self.bleShield.peripherals = nil;
    }
    [self.bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}


@end
