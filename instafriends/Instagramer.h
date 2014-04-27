//
//  Instagramer.h
//  instafriends
//
//  Created by Daniel Camargo on 13/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Instagramer : NSManagedObject

@property (nonatomic, retain) NSNumber * addedAs;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * profilePicture;
@property (nonatomic, retain) NSString * relationship;
@property (nonatomic, retain) NSString * username;

@end
