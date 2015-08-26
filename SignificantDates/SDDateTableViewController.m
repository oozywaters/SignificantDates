//
//  SDDateTableViewController.m
//  SignificantDates
//
//  Created by Vyacheslav Zavertanny on 25/08/15.
//  Copyright (c) 2015 Vyacheslav Zavertanny. All rights reserved.
//

#import "SDDateTableViewController.h"
#import "SDCoreDataController.h"
#import "SDTableViewCell.h"
#import "SDAddDateViewController.h"
#import "SDDateDetailViewController.h"
#import "Holiday.h"
#import "Birthday.h"

@interface SDDateTableViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation SDDateTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
        self.dates = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 75.0;
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self loadRecordsFromCoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dates count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDTableViewCell *cell = nil;
    
    if ([self.entityName isEqualToString:@"Holiday"]) {
        static NSString *CellIdentifier = @"HolidayCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Holiday *holiday = [self.dates objectAtIndex:indexPath.row];
        cell.nameLabel.text = holiday.name;
        cell.dateLabel.text = [self.dateFormatter stringFromDate:holiday.date];
        if (holiday.image != nil) {
            UIImage *image = [UIImage imageWithData:holiday.image];
            cell.imageView.image = image;
        } else {
            cell.imageView.image = nil;
        }
    } else { // Birthday
        static NSString *CellIdentifier = @"BirthdayCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Birthday *birthday = [self.dates objectAtIndex:indexPath.row];
        cell.nameLabel.text = birthday.name;
        cell.dateLabel.text = [self.dateFormatter stringFromDate:birthday.date];
        if (birthday.image != nil) {
            UIImage *image = [UIImage imageWithData:birthday.image];
            cell.imageView.image = image;
        } else {
            cell.imageView.image = nil;
        }
    }
    
    
    return cell;

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *date = [self.dates objectAtIndex:indexPath.row];
        [self.managedObjectContext performBlockAndWait:^{
            [self.managedObjectContext deleteObject:date];
            NSError *error = nil;
            BOOL saved = [self.managedObjectContext save:&error];
            if (!saved) {
                NSLog(@"Error saving main context: %@", error);
            }
            
            [[SDCoreDataController sharedInstance] saveMasterContext];
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
    }
}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDateDetailViewSegue"]) {
        SDDateDetailViewController *dateDetailViewController = segue.destinationViewController;
        SDTableViewCell *cell = (SDTableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Holiday *holiday = [self.dates objectAtIndex:indexPath.row];
        dateDetailViewController.managedObjectId = holiday.objectID;
        
    } else if ([segue.identifier isEqualToString:@"ShowAddDateViewSegue"]) {
        SDAddDateViewController *addDateViewController = segue.destinationViewController;
        [addDateViewController setAddDateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
        
    }
}


@end
