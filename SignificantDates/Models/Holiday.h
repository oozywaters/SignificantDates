//
//  Holiday.h
//  SignificantDates
//
//  Created by Vyacheslav Zavertanny on 25/08/15.
//  Copyright (c) 2015 Vyacheslav Zavertanny. All rights reserved.
//

@interface Holiday : NSManagedObject

@property (nonatomic, retain) NSString * wikipediaLink;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) id observedBy;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * createdAt;

@end
