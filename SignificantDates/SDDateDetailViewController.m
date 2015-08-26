//
//  SDDateDetailViewController.m
//  SignificantDates
//
//  Created by Vyacheslav Zavertanny on 25/08/15.
//  Copyright (c) 2015 Vyacheslav Zavertanny. All rights reserved.
//

#import "SDDateDetailViewController.h"
#import "SDCoreDataController.h"
#import "Holiday.h"
#import "Birthday.h"

enum SDDateType {
    SDDateHoliday,
    SDDateBirthday
};

typedef enum {
    SDHolidayDateCell = 0,
    SDHolidayDetailsCell = 1,
    SDHolidayObservedByCell = 2,
    SDHolidayWikipediaCell = 3
} SDHolidayCell;

typedef enum {
    SDBirthdayDateCell = 0,
    SDBirthdayGiftIdeasCell = 1,
    SDBirthdayFacebookCell = 2
} SDBirthdayCell;


@interface SDDateDetailViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property enum SDDateType dateType;

@end

@implementation SDDateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.context = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.managedObject = [self.context objectWithID:self.managedObjectId];
//
    self.title = [self.managedObject valueForKey:@"name"];
    self.imageView.image = [UIImage imageWithData:[self.managedObject valueForKey:@"image"]];
    if ([self.managedObject isKindOfClass:[Holiday class]]) {
        self.dateType = SDDateHoliday;
    } else {
        self.dateType = SDDateBirthday;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DateDetailViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (self.dateType == SDDateHoliday) {
        Holiday *holiday = (Holiday *)self.managedObject;
        if (indexPath.row == SDHolidayDateCell) {
            cell.textLabel.text = @"Date";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            cell.detailTextLabel.text = [dateFormatter stringFromDate:holiday.date];
        } else if (indexPath.row == SDHolidayDetailsCell) {
            cell.textLabel.text = @"Details";
            cell.detailTextLabel.text = holiday.details;
        } else if (indexPath.row == SDHolidayObservedByCell) {
            cell.textLabel.text = @"Observed By";
            cell.detailTextLabel.text = [holiday.observedBy componentsJoinedByString:@", "];
        } else if (indexPath.row == SDHolidayWikipediaCell) {
            cell.textLabel.text = @"Wikipedia";
            if (![holiday.wikipediaLink isEqualToString:@""]) {
                cell.detailTextLabel.text = @"View on Wikipedia";
            } else {
                cell.detailTextLabel.text = @"Search by Name";
            }
        }
        
    } else if (self.dateType == SDDateBirthday) {
        Birthday *birthday = (Birthday *)self.managedObject;
        if (indexPath.row == SDBirthdayDateCell) {
            cell.textLabel.text = @"Date";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            cell.detailTextLabel.text = [dateFormatter stringFromDate:birthday.date];
        } else if (indexPath.row == SDBirthdayGiftIdeasCell) {
            cell.textLabel.text = @"Gift Ideas";
            cell.detailTextLabel.text = birthday.giftIdeas;
        } else if (indexPath.row == SDBirthdayFacebookCell) {
            cell.textLabel.text = @"Facebook";
            if (![birthday.facebook isEqualToString:@""]) {
                cell.detailTextLabel.text = birthday.facebook;
            } else {
                cell.detailTextLabel.text = @"Search Facebook";
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dateType == SDDateHoliday) {
        Holiday *holiday = (Holiday *)self.managedObject;
        if (indexPath.row == SDHolidayWikipediaCell) {
            
            BOOL validURL = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:holiday.wikipediaLink]];
            if (!validURL) {
                NSString *urlString = [NSString
                                       stringWithFormat:@"http://m.wikipedia.org/wiki/%@", holiday.name];
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
        }
    } else if (self.dateType == SDDateBirthday) {
        Birthday *birthday = (Birthday *)self.managedObject;
        if (indexPath.row == SDBirthdayFacebookCell) {
            if (birthday.facebook) {
                NSString *urlString = [NSString
                                       stringWithFormat:@"http://facebook.com/%@", birthday.facebook];
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            } else {
                NSString *urlString = [NSString
                                       stringWithFormat:@"https://www.facebook.com/search/results.php?q=%@", birthday.name];
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (self.dateType == SDDateHoliday) {
        rows = 4;
    } else if (self.dateType == SDDateBirthday) {
        rows = 3;
    }
    
    return rows;
}

@end
