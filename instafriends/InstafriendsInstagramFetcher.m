	//
//  InstafriendsInstagramFetcher.m
//  instafriends
//
//  Created by Daniel Camargo on 31/07/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsInstagramFetcher.h"
#import "InstafriendsConstants.h"
#import "Instagramer.h"

@interface InstafriendsInstagramFetcher()
- (NSDictionary *)peoploWhoFollowTheUser:( NSString * )userID byToken:( NSString * ) userToken;
- (NSDictionary *)peoploFollowedByTheUser:( NSString * )userID byToken:( NSString * ) userToken;
- (NSDictionary *) parseArrayToDictionary:(NSArray*)users;
- (NSArray *)executeInstagramFetch:(NSString *)url;

@property (nonatomic, strong) NSString *statusPrefix;
@property (nonatomic) int statusCount;
@end

@implementation InstafriendsInstagramFetcher

@synthesize delegate = _delegate;
@synthesize statusPrefix = _statusPrefix;
@synthesize statusCount = _statusCount;

- (NSArray *)executeInstagramFetch:(NSString *)url
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableArray *results = [[NSMutableArray alloc]init];
    NSDictionary *requestResult = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;

    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    if([[requestResult objectForKey:@"data"] isKindOfClass:[NSArray class]]){
        [results addObjectsFromArray: [requestResult objectForKey:@"data"]];
    }

    if ( (self.statusCount + [results count]) > self.statusCount) {
        self.statusCount = self.statusCount + [results count];
        [self.delegate showTheInstagramFetcherStatus: self.statusPrefix andCount:self.statusCount];
    }
    
    if((int)[requestResult valueForKey:@"code"] != 200){
        if( [requestResult valueForKey:@"pagination"] && [[requestResult valueForKey:@"pagination"] valueForKey:@"next_url"] ){
            NSString *nextUrl = [[requestResult valueForKey:@"pagination"] valueForKey:@"next_url"];
            [results addObjectsFromArray: [self executeInstagramFetch:nextUrl]];
        }
    } else {
// TODO: Exception here
        NSLog(@"You have exceeded the maximum number of requests per hour. d");
    }
    return [NSArray arrayWithArray:results];
}

-(NSDictionary *) sortDatas:( NSString * )userID byToken:( NSString * ) userToken{
    
    NSDictionary *theUserIsFollowedBy = [self peoploWhoFollowTheUser:userID byToken:userToken];
    NSDictionary *theUserFollows = [self peoploFollowedByTheUser:userID byToken:userToken];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    
    NSDate *now = [NSDate date];
    
    for (NSString* username in theUserIsFollowedBy) {
        id userInfo = [theUserIsFollowedBy objectForKey:username];
        if( [userInfo isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
            [user setValue:now forKey:@"data"];
            if([theUserFollows objectForKey:username]){
                [user setValue:INSTAFRIENDS_RELATION_FRIEND forKey:@"relationship"];
            }else{
                [user setValue:INSTAFRIENDS_RELATION_FAN forKey:@"relationship"];
            }
            [result setObject:user forKey:username];
        }
    }

    for (NSString* username in theUserFollows) {
        id userInfo = [theUserFollows objectForKey:username];
        if( [userInfo isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
            [user setValue:now forKey:@"data"];
            if([theUserIsFollowedBy objectForKey:username]){
                [user setValue:INSTAFRIENDS_RELATION_FRIEND forKey:@"relationship"];
            }else{
                [user setValue:INSTAFRIENDS_RELATION_FOLLOWING forKey:@"relationship"];
            }
            [result setObject:user forKey:username];
        }
    }
    return result;
    
}

-(NSDictionary *) parseArrayToDictionary:(NSArray*) users
{
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    for(id user in users) {
        if ([user isKindOfClass:[NSDictionary class]]){
            [results setObject:user forKey:[user valueForKey:@"username"]];
        }
    }
    return [NSDictionary dictionaryWithDictionary:results] ;
}

- (NSDictionary *)peoploWhoFollowTheUser:( NSString * )userID byToken:( NSString * ) userToken
{
    [self setStatusCount:0];
    [self setStatusPrefix:@"Loading the users that follow you: %d"];
    [self.delegate showTheInstagramFetcherStatus: self.statusPrefix andCount:self.statusCount];
    NSString *request = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/followed-by?count=100&access_token=%@", userID, userToken];
    return [self parseArrayToDictionary:[self executeInstagramFetch:request]];
}

-(NSDictionary *)peoploFollowedByTheUser:( NSString * )userID byToken:( NSString * ) userToken
{
    [self setStatusCount:0];
    [self setStatusPrefix:@"Loading the users that you follow: %d"];
    [self.delegate showTheInstagramFetcherStatus: self.statusPrefix andCount:self.statusCount];
    NSString *request = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/follows?count=100&access_token=%@", userID, userToken];
    return [self parseArrayToDictionary:[self executeInstagramFetch:request]];
}

+(void)followTheUser:(NSString *) token{
    NSString *post = @"key1=val1&key2=val2";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.nowhere.com/sendFormHere.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
}

+(NSMutableDictionary*)loadUserInfoByToken:(NSString *) token{
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/?access_token=%@", token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableArray *results = [[NSMutableArray alloc]init];
    NSDictionary *requestResult = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    if([[requestResult objectForKey:@"data"] isKindOfClass:[NSArray class]]){
        [results addObjectsFromArray: [requestResult objectForKey:@"data"]];
    }
    if( [requestResult valueForKey:@"meta"] &&
        [[requestResult valueForKey:@"meta"] valueForKey:@"code"] ){
        [userInfo setValue:[[requestResult objectForKey:@"data"] objectForKey:@"id"] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_ID];
        [userInfo setValue:[[requestResult objectForKey:@"data"] objectForKey:@"username"] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_USERNAME];
        [userInfo setValue:[[requestResult objectForKey:@"data"] objectForKey:@"profile_picture"] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_PROFILE_PICTURE];
        [userInfo setValue:[[requestResult objectForKey:@"data"] objectForKey:@"full_name"] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_FULL_NAME];
        [userInfo setValue:[[[requestResult objectForKey:@"data"] objectForKey:@"counts"] objectForKey:@"media"] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_MEDIA];
        [userInfo setValue:[[[requestResult objectForKey:@"data"] objectForKey:@"counts"] objectForKey:@"followed_by"] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWED_BY];
        [userInfo setValue:[[[requestResult objectForKey:@"data"] objectForKey:@"counts"] objectForKey:@"follows"] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWS];
    } else {
// TODO: Exception here
        NSLog(@"You have exceeded the maximum number of requests per hour.");
    }
    return [NSDictionary dictionaryWithDictionary:userInfo];
}

+(void)followUserID:(NSString * ) userID usingTheToken:( NSString * ) token
{
    [self changeRelationshipTo:@"follow" theUser:userID usingTheToken:token];
}

+(void)unfollowUserID:(NSString * ) userID usingTheToken:( NSString * ) token
{
    [self changeRelationshipTo:@"unfollow" theUser:userID usingTheToken:token];
}

+(void)changeRelationshipTo:(NSString*)relationship theUser:(NSString*)userID usingTheToken:( NSString * ) token{
    NSString *url = [[NSString alloc]initWithFormat:@"https://api.instagram.com/v1/users/%@/relationship",userID];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSString *post =[[NSString alloc] initWithFormat:@"access_token=%@&action=%@", token, relationship];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
// TODO: Exception here
         if([data length] > 0 && error == nil){
             // NSLog(@"responseData:%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
         }  else if ([data length] == 0 && error == nil){
             // [delegate emptyReply];
         } else if (error != nil){
             // [delegate downloadError:error];
         }
     }];

}

@end
