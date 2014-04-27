//
//  Instagramer+DataBase.h
//  instafriends
//
//  Created by Daniel Camargo on 31/07/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "Instagramer.h"

@interface Instagramer (DataBase)
+ (void)addInstagramer:(NSDictionary *)instagramers inManagedObjectContext:(NSManagedObjectContext *)context;
+(NSArray *) instagramerListByPredicate:(NSPredicate *) predicate withContext:(NSManagedObjectContext *) context;
+(void) instagramerChange:(Instagramer*)instagramer toRelation:(NSString *)relation;
+(NSInteger) countResultsOfFollowingswithContext:(NSManagedObjectContext *) context;
+(NSInteger) countResultsOfFanswithContext:(NSManagedObjectContext *) context;
+(NSInteger) countResultsOfFriendswithContext:(NSManagedObjectContext *) context;
+ (void) deleteAllObjectsWithContext:(NSManagedObjectContext *) context;
@end
