//
//  InstafriendsUserDefaults.h
//  instafriends
//
//  Created by Daniel Camargo on 08/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstafriendsUserDefaults : NSObject

+(void)saveToken:(NSString *)token;
+(void)saveUserInfo:(NSDictionary *)userInfo;
+(void)deleteUserDefaults;
+(void)saveLastUpdate;

+(BOOL)isUserLoggedIn;
+(BOOL)doesItHasInfo;

+(NSString *) getID;
+(NSString *) getProfilePicture;
+(NSString *) getUsername;
+(NSString *) getToken;
+(NSString *) getFullName;
+(NSString *) getLastUpdate;
+(NSString *) getFollowedBy;
+(NSString *) getFollows;
+(NSString *) getMedia;

@end
