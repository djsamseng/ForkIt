//
//  ViewController.m
//  IEDFork
//
//  Created by Samuel Seng on 10/23/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "ViewController.h"
#import "IEDDataModel.h"
#import "IEDBluetoothBLE.h"


@interface ViewController ()


@property (strong, nonatomic) IBOutlet UIImageView *plateView;
@property (strong, nonatomic) IBOutlet UITextView *foodText;
@property (strong, nonatomic) NSString *foodString;
@property (strong, nonatomic) IBOutlet UITextField *statusText;
@property (nonatomic) int resistance;
@property (nonatomic) int resistance2;
@property (nonatomic) int temperature;

@property (strong, nonatomic) IEDDataModel *dataModel;
@property (strong, nonatomic) IEDBluetoothBLE *bluetooth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.statusText setText:@"Status: Disconnected"];
    self.statusText.textColor = [UIColor redColor];
    
    CGFloat statusWidth = self.plateView.bounds.size.width * 0.8f;
    [self.statusText setBounds:CGRectMake(self.statusText.bounds.origin.x, self.statusText.bounds.origin.y, statusWidth, self.statusText.bounds.size.height)];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Wood_Board_Small.jpg"] drawInRect:self.view.bounds];
    //Credit: http://www.pageresource.com/wallpapers/4462/textures-wood-board-free-hd-wallpaper.html
    //Plate Credit: http://www.worldmarket.com/product/white-coupe-square-salad-plate-set-of-4.do?&from=fn
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.resistance = 0;
    self.resistance2 = 0;
    self.temperature = 0;
    [self.foodText setEditable:NO];
    [self.statusText setEnabled:NO];
    self.foodString = @"Tap to identify";
    self.foodText.text = self.foodString;
    if (self.bluetooth == nil) {
        self.bluetooth = [[IEDBluetoothBLE alloc] init];
        self.bluetooth.delegate = self;
    }
    
    //Model & Core Data intitialization
    if (self.dataModel == nil) {
        self.dataModel = [[IEDDataModel alloc] init];
    }
    if ([self.dataModel.allItems count] == 0) {
        [self.dataModel loadJSONData];
    }
    [self.dataModel checkForUpdatedData];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setFoodTextWithTopString {
    self.foodText.text = self.foodString;
    [self.foodText setFont:[UIFont systemFontOfSize:36.0]];
    [self.foodText setTextAlignment:NSTextAlignmentCenter];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [self setFoodTextWithTopString];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mainViewTapped:(id)sender {
    [self identifyPressed];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)identifyPressed {
    if ([self.bluetooth isConnected]) {
        NSString *result = [self.dataModel identifyFood:self.resistance :self.resistance2];
        self.foodString = result;
        [self setFoodTextWithTopString];
        NSString *voiceString = [NSString stringWithFormat:@"%@.      %d point %d degrees fahrenheit", result, self.temperature / 10, self.temperature % 10];
        [self.flite say:voiceString withVoice:self.s];
    } else {
        [self.bluetooth connect];
    }
}

#pragma mark - Bluetooth

- (void)bluetoothConnectFinished:(BOOL)success {
    if (success) {
        [self.statusText setText:@"Status: Connected"];
        [self.statusText setTextColor:[UIColor blackColor]];
        [self.statusText sizeToFit];
        [self.flite say:@"Tap to identify     or swipe to limit your options" withVoice:self.s];
    } else {
        [self.statusText setText:@"Status: Disconnected"];
        [self.statusText setTextColor:[UIColor redColor]];
        [self.statusText sizeToFit];
        [self.flite say:@"Disconnected.         Turn on device      and tap to continue" withVoice:self.s];
    }
}

- (void)bluetoothConnecting {
    [self.statusText setText:@"Status: Connecting"];
    [self.statusText setTextColor:[UIColor blackColor]];
    [self.statusText sizeToFit];
    [self.flite say:@"Connecting" withVoice:self.s];
}

- (void)dataReceived:(int)value :(BOOL)isResistance :(BOOL)isResistance2 :(BOOL)isTemperature {
    if (isResistance) {
        self.resistance = value;
    } else if (isResistance2) {
        self.resistance2 = value;
    } else if (isTemperature) {
        self.temperature = value;
    }
}

- (void)bluetoothAttemptConnect {
    [self.bluetooth connect];
}


#pragma mark - Voice Commands

- (FliteController *)flite {  //controls the voice
	if (self.fliteController == nil) {
		self.fliteController = [[FliteController alloc] init];
	}
	return self.fliteController;
}

- (Slt *)s { //voice, might want to change
	if (self.slt == nil) {
		self.slt = [[Slt alloc] init];
	}
	return self.slt;
}



@end
