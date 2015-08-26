//
//  SDAddDateViewController.m
//  SignificantDates
//
//  Created by Vyacheslav Zavertanny on 25/08/15.
//  Copyright (c) 2015 Vyacheslav Zavertanny. All rights reserved.
//

#import "SDAddDateViewController.h"
#import "SDCoreDataController.h"

@interface SDAddDateViewController ()

@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *date;

@end

@implementation SDAddDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.date = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    self.datePicker.date = [NSDate date];
}

- (void)viewDidAppear:(BOOL)animated {
    self.originalCenter = self.view.center;
}

- (IBAction)saveButtonTouched:(UIBarButtonItem *)sender {
    if (![self.nameTextField.text isEqualToString:@""] && self.datePicker.date) {
        [self.date setValue:self.nameTextField.text forKey:@"name"];
        [self.date setValue:[self dateSetToMidnightUsingDate:self.datePicker.date] forKey:@"date"];
        [self.date setValue:[self dateSetToMidnightUsingDate:self.datePicker.date] forKey:@"updatedAt"];
        if ([self.entityName isEqualToString:@"Holiday"]) {
            [self.date setValue:self.option1TextField.text forKey:@"details"];
            [self.date setValue:self.option2TextField.text forKey:@"wikipediaLink"];
        } else if ([self.entityName isEqualToString:@"Birthday"]) {
            [self.date setValue:self.option1TextField.text forKey:@"giftIdeas"];
            [self.date setValue:self.option2TextField.text forKey:@"facebook"];
        }
        [self.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            BOOL saved = [self.managedObjectContext save:&error];
            if (!saved) {
                // do some real error handling
                NSLog(@"Could not save Date due to %@", error);
            }
            [[SDCoreDataController sharedInstance] saveMasterContext];
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        [self addDateCompletionBlock];
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Uh oh..." message:@"You must at least set a name and date" delegate:nil cancelButtonTitle:@"Duh" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }

}

- (IBAction)setDateButtonTouched:(UIButton *)sender {
    [self.nameTextField resignFirstResponder];
    [self.option1TextField resignFirstResponder];
    [self.option2TextField resignFirstResponder];
    
    if (self.datePicker.isHidden) {
        [self.datePicker setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setCenter:CGPointMake(self.originalCenter.x, self.originalCenter.y-30)];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setCenter:self.originalCenter];
        } completion:^(BOOL finished) {
            [self.datePicker setHidden:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDate *)dateSetToMidnightUsingDate:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSUIntegerMax fromDate:aDate];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [gregorian dateFromComponents: components];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
