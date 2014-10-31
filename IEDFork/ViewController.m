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
#import "IEDAddEntryTableViewController.h"

@interface ViewController ()



@property (strong, nonatomic) IBOutlet UITextView *textReceived;
@property (strong, nonatomic) IBOutlet UITextView *foodText;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (nonatomic) int resistance;
@property (nonatomic) int temperature;

@property (strong, nonatomic) IEDDataModel *dataModel;
@property (strong, nonatomic) IEDBluetoothBLE *bluetooth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textReceived.text=NULL;
    self.resistance = 0;
    self.temperature = 0;
    [self.textReceived setEditable:NO];
    [self.foodText setEditable:NO];
    if (self.bluetooth == nil) {
        self.bluetooth = [[IEDBluetoothBLE alloc] init];
        self.bluetooth.delegate = self;
    }
    
    //Model & Core Data intitialization
    self.dataModel = [[IEDDataModel alloc] init];
    if ([self.dataModel.allItems count] == 0) {
        IEDFood *newFood = [self.dataModel createFood];
        newFood.foodName = @"Test food";
        [self.dataModel saveChanges];
    }
    NSMutableString *allFoods = [[NSMutableString alloc] init];
    for (IEDFood *food in self.dataModel.allItems) {
        [allFoods appendFormat:@" %@", food.foodName];
    }
    //self.foodText.text = allFoods;
    
    /*//Voice commands initialization
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    NSArray* words = [NSArray arrayWithObjects:@"YES", @"CONNECT", nil];
    NSString*name = @"recognitionwords";
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
    
    NSDictionary *languageGeneratorResults = nil;
    
    NSString *lmPath = nil;
    NSString *dicPath = nil;
    
    if([err code] == noErr) {
        
        languageGeneratorResults = [err userInfo];
		
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    
    
    [self.openEars setDelegate:self];
    
    [self.pocket startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];*/
    
  
    
    //[self.flite say:@"For instructions say yes" withVoice:self.s];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"AddEntrySegue"]) {
        IEDAddEntryTableViewController *avc = [segue destinationViewController];
        avc.dataModel = self.dataModel;
        avc.resistance = self.resistance;
        avc.temperature = self.temperature;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)identifyPressed:(id)sender {
    NSString *result = [self.dataModel identifyFood:self.resistance];
    self.foodText.text = result;
    [self.foodText setFont:[UIFont systemFontOfSize:36.0]];
    [self.foodText setTextAlignment:NSTextAlignmentCenter];
}

- (IBAction)bleConnectPressed:(id)sender {
    self.connectButton.titleLabel.text = @"Connecting...";
    [self.connectButton.titleLabel sizeToFit];
    [self.bluetooth connect];
}

#pragma mark - Bluetooth

- (void)bluetoothConnectFinished:(BOOL)success {
    if (success) {
        self.connectButton.titleLabel.text = @"Disconnect";
        [self.connectButton.titleLabel sizeToFit];
    } else {
        self.connectButton.titleLabel.text = @"Connect";
        [self.connectButton sizeToFit];
    }
}

- (void)dataReceived:(int)resistance :(int)temperature {
    self.resistance = resistance;
    self.temperature = temperature;
    self.textReceived.text = [NSString stringWithFormat:@"%dΩ %dC", resistance, temperature];
    [self.textReceived setFont:[UIFont systemFontOfSize:36.0]];
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
- (PocketsphinxController *)pocket{
	if (self.pocketsphinxController == nil) {
		self.pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return self.pocketsphinxController;
}
- (OpenEarsEventsObserver *)openEars {
	if (self.openEarsEventsObserver == nil) {
		self.openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return self.openEarsEventsObserver;
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    if([hypothesis isEqualToString:@"YES"])
    {
        [self.flite say:@"Welcome to Fork  It. Forblue tooth connection please say the command: Connect" withVoice:self.s];
        self.textReceived.text= @"You said Yes";
        
        
    }
    if([hypothesis isEqualToString:@"CONNECT"]){
        
        [self bleConnectPressed:nil];
        self.textReceived.text= @"You said Connect";
    }
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
    
	NSLog(@"Pocketsphinx has detected speech.");
    
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}
- (void) testRecognitionCompleted {
	NSLog(@"A test file that was submitted for recognition is now complete.");
}


@end
