//
//  IEDAddEntryTableViewController.m
//  IEDFork
//
//  Created by Samuel Seng on 10/27/14.
//  Copyright (c) 2014 Samuel Seng. All rights reserved.
//

#import "IEDAddEntryTableViewController.h"
#import "IEDFoodAttribute.h"


@interface IEDAddEntryTableViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) IEDFood *selectedFood;

@end

@implementation IEDAddEntryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)newFoodClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New food" message:@"Enter food name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"New food";
    [alert setTag:1];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            NSString *textEntered = [[alertView textFieldAtIndex:0] text];
            if ([textEntered length] > 0 && ![self.dataModel foodExists:textEntered]) {
                IEDFood *newFood = [self.dataModel createFood];
                newFood.foodName = textEntered;
                [self.dataModel saveChanges];
            }
        }
    } else if (alertView.tag == 2) {
        
    } else if (alertView.tag == 3) {
        if (buttonIndex == 1 && self.selectedFood != nil) {
            [self addAttributeToFood:self.selectedFood];
        } else {
            self.selectedFood = nil;
        }
    }
}

- (void)addAttributeToFood:(IEDFood *)foodType {
    IEDFoodAttribute *attribute = [self.dataModel createAttribute:self.selectedFood];
    attribute.resistance = self.resistance;
    attribute.temperature = self.temperature;
    [self.dataModel saveChanges];

}

@synthesize resistance = _resistance;
-(int)resistance {
    return _resistance;
}
-(void)setResistance:(int)resistance {
    _resistance = resistance;
    self.title = [NSString stringWithFormat:@"%dΩ %dC", _resistance, _temperature];
}
@synthesize temperature = _temperature;
-(int)temperature {
    return _temperature;
}
-(void)setTemperature:(int)temperature {
    _temperature = temperature;
    self.title = [NSString stringWithFormat:@"%dΩ %dC", _resistance, _temperature];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.dataModel != nil) {
        return [self.dataModel.allItems count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    IEDFood *foodItem = [self.dataModel.allItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %d", foodItem.foodName, foodItem.attributeValues.count];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedFood = [self.dataModel.allItems objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:[NSString stringWithFormat:@"Confirm %dΩ %dC for %@", self.resistance, self.temperature, self.selectedFood.foodName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert setTag:3];
    [alert show];
}

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
