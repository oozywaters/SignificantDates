//
//  Birthday.h
//  SignificantDates
//
//  Created by Vyacheslav Zavertanny on 25/08/15.
//  Copyright (c) 2015 Vyacheslav Zavertanny. All rights reserved.
//

@interface Birthday : NSManagedObject

@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * giftIdeas;
@property (nonatomic, retain) NSString * facebook;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * createdAt;

@end
