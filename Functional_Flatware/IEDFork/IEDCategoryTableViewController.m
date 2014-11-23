//
//  IEDCategoryTableViewController.m
//  Functional Flatware
//
//  Created by Samuel Seng on 11/15/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "IEDCategoryTableViewController.h"
#import "IEDNavigationController.h"
#import "ViewController.h"
#import <ApiAI/ApiAI.h>
#import <ApiAI/AIVoiceRequest.h>


@interface IEDCategoryTableViewController ()
@property (strong, nonatomic) NSTimer *autoConnectTimer;
@property (nonatomic) BOOL categoryWasSet;
@end

@implementation IEDCategoryTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:recognizer];
    
    // Uncomment the following line to preserve selection between presentations.
    
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)handleSwipe {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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

- (BOOL)containsString:(NSString *)string : (NSString *)toFind {
    NSRange range = [string rangeOfString:toFind];
    if (range.location > 500) {
        return false;
    }
    return true;
}

- (void)listenForCategory {
    AIVoiceRequest *request = (AIVoiceRequest *)[_apiAI requestWithType:AIRequestTypeVoice];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        NSString*newString=[response description];
        if ([self containsString:newString :@"greens"]) {
            IEDNavigationController *nav = (IEDNavigationController*)self.navigationController;
            nav.category = @"Greens";
            self.categoryWasSet = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"%@", response);
        } else if ([self containsString:newString :@"milk"]) {
            IEDNavigationController *nav = (IEDNavigationController*)self.navigationController;
            nav.category = @"Milk";
            self.categoryWasSet = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"%@", response);
        } else if ([self containsString:newString :@"meat"]){
            NSLog(@"%@", response);
            IEDNavigationController *nav = (IEDNavigationController*)self.navigationController;
            nav.category = @"Meat";
            self.categoryWasSet = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if ([self containsString:newString :@"Fruit"]){
            IEDNavigationController *nav = (IEDNavigationController*)self.navigationController;
            nav.category = @"Fruit";
            self.categoryWasSet = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(AIRequest *request, NSError *error) {
        // Handle error ...
        NSLog(@"@error");
        
    }];
    self.voiceRequest = request;
    [_apiAI enqueue:request];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self listenForCategory];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.voiceRequest != nil && [self.voiceRequest isExecuting]) {
        [self.voiceRequest cancel];
    }
    self.voiceRequest = nil;
    if (!self.categoryWasSet) {
        ((IEDNavigationController *)self.navigationController).category = @"";
    }
    self.categoryWasSet = NO;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    
    
    // Return the number of rows in the section.
    
    
    
    return [self.selection count];
    
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static  NSString *CellIdentifier = @"ListPrototypeCell";
    
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    
    
    cell.textLabel.text = [self.selection objectAtIndex:indexPath.row];
    
    
    
    return cell;
    
    
    
    
    
}

/*
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 
 
 // Configure the cell...
 
 
 
 return cell;
 
 }
 
 */



/*
 
 // Override to support conditional editing of the table view.
 
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 
 // Return NO if you do not want the specified item to be editable.
 
 return YES;
 
 }
 
 */



/*
 
 // Override to support editing the table view.
 
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 
 // Delete the row from the data source
 
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 
 }
 
 }
 
 */



/*
 
 // Override to support rearranging the table view.
 
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 
 }
 
 */



/*
 
 // Override to support conditional rearranging of the table view.
 
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 
 // Return NO if you do not want the item to be re-orderable.
 
 return YES;
 
 }
 
 */



/*
 
 #pragma mark - Navigation
 
 
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 // Get the new view controller using [segue destinationViewController].
 
 // Pass the selected object to the new view controller.
 
 }
 
 */



@end
