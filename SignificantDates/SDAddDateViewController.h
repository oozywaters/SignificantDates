//
//  SDAddDateViewController.h
//  SignificantDates
//
//  Created by Vyacheslav Zavertanny on 25/08/15.
//  Copyright (c) 2015 Vyacheslav Zavertanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDAddDateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *option1TextField;
@property (weak, nonatomic) IBOutlet UITextField *option2TextField;
@property (weak, nonatomic) IBOutlet UIButton *setDateButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) NSString *entityName;

@property (copy, nonatomic) void (^addDateCompletionBlock)(void);

- (IBAction)setDateButtonTouched:(id)sender;
- (IBAction)saveButtonTouched:(id)sender;

@end
