//
//  InstafriendsInstagramFetcher.h
//  instafriends
//
//  Created by Daniel Camargo on 31/07/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INSTAGRAM_API_FOLLOWME_URL @""

@protocol InstafriendsInstagramFetcherListenner <NSObject>

-(void)showTheInstagramFetcherStatus:(NSString *)statusLabel andCount:(int)count;

@end

@interface InstafriendsInstagramFetcher : NSObject

@property (nonatomic, weak) id <InstafriendsInstagramFetcherListenner> delegate;

- (NSDictionary *) sortDatas:( NSString * )userID byToken:( NSString * ) userToken;
+(NSMutableDictionary*)loadUserInfoByToken:(NSString *) token;
+(void)followUserID:(NSString * ) userID usingTheToken:( NSString * ) token;
+(void)unfollowUserID:(NSString * ) userID usingTheToken:( NSString * ) token;

@end
