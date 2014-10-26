//
//  ViewController.m
//  IEDFork
//
//  Created by Samuel Seng on 10/23/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textReceived;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) BLE *bleShield;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bleShield = [[BLE alloc] init];
    [self.bleShield controlSetup];
    self.bleShield.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    self.textReceived.text = s;
}

NSTimer *rssiTimer;

- (void)readRSSITimer:(NSTimer *)timer
{
    [self.bleShield readRSSI];
}

- (void)bleDidDisconnect
{
    [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    [rssiTimer invalidate];
}

-(void)bleDidConnect
{
    [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}

-(void)bleDidUpdateRSSI:(NSNumber *)rssi {
}
- (IBAction)bleConnectPressed:(id)sender {
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
