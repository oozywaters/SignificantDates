//
//  SDDateDetailViewController.h
//  SignificantDates
//
//  Created by Vyacheslav Zavertanny on 25/08/15.
//  Copyright (c) 2015 Vyacheslav Zavertanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDDateDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@end
