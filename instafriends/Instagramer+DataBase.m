//
//  Instagramer+DataBase.m
//  instafriends
//
//  Created by Daniel Camargo on 31/07/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "Instagramer+DataBase.h"
#import "InstafriendsConstants.h"

@implementation Instagramer (DataBase)
/*
for (NSDictionary *username in users) {
    id userInfo = [users objectForKey:username];
    if( [userInfo isKindOfClass:[NSDictionary class]]){
        [Instagramer addInstagramer:userInfo inManagedObjectContext:document.managedObjectContext];
    }
}
*/

+ (void)addInstagramer:(NSDictionary *)instagramers inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Instagramer"];
    NSError *error = nil;
    for (NSDictionary *username in instagramers) {
        id instagramerInfo = [instagramers objectForKey:username];
        if( [instagramerInfo isKindOfClass:[NSDictionary class]]){
            Instagramer *instagramer = nil;
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@",[instagramerInfo valueForKey:@"id"]];
            NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
            if ([matches count] == 0) {
                instagramer = [NSEntityDescription insertNewObjectForEntityForName:@"Instagramer" inManagedObjectContext:context];
                instagramer.id = [instagramerInfo valueForKey:@"id"];
                instagramer.username = [instagramerInfo valueForKey:@"username"];
                instagramer.profilePicture = [instagramerInfo valueForKey:@"profile_picture"];
                instagramer.fullName = [instagramerInfo valueForKey:@"full_name"];
                instagramer.date = [instagramerInfo valueForKey:@"date"];
                instagramer.relationship = [instagramerInfo valueForKey:@"relationship"];
                instagramer.addedAs = [instagramerInfo valueForKey:@"addedAs"];
                [context insertObject:instagramer];
            }
        }
    }
}

+(NSArray *) instagramerListByPredicate:(NSPredicate *) predicate withContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Instagramer"];
    if(predicate){
        request.predicate = predicate;
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    return matches;
}

+(void) instagramerChange:(Instagramer*)instagramer toRelation:(NSString *)relationship{
    [instagramer setValue:relationship forKey:@"relationship"];
    NSError *error;
    if (![instagramer.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }else{
        NSLog(@"saved");
    }
}

+(NSInteger) countResultsByPredicate:(NSPredicate *) predicate withContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Instagramer"];
    if(predicate){
        request.predicate = predicate;
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    return [matches count];
}

+(NSInteger) countResultsOfFriendswithContext:(NSManagedObjectContext *) context
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"relationship = %@",INSTAFRIENDS_RELATION_FRIEND];
    return [self countResultsByPredicate:predicate withContext:context];
}

+(NSInteger) countResultsOfFanswithContext:(NSManagedObjectContext *) context
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"relationship = %@",INSTAFRIENDS_RELATION_FAN];
    return [self countResultsByPredicate:predicate withContext:context];
}

+(NSInteger) countResultsOfFollowingswithContext:(NSManagedObjectContext *) context
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"relationship = %@",INSTAFRIENDS_RELATION_FOLLOWING];
    return [self countResultsByPredicate:predicate withContext:context];
}

+(void) deleteAllObjectsWithContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Instagramer"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *items = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
    if (![context save:&error]) {
// All itens deleted
    }
}
@end
