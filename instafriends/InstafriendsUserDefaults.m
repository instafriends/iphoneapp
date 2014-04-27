//
//  InstafriendsUserDefaults.m
//  instafriends
//
//  Created by Daniel Camargo on 08/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsUserDefaults.h"
#import "InstafriendsConstants.h"

@implementation InstafriendsUserDefaults

+(void)saveToken:(NSString *)token
{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject:token forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_TOKEN];
    [userinfo synchronize];
}

+(void)saveLastUpdate
{
    NSUserDefaults *userinfoDefaults = [NSUserDefaults standardUserDefaults];
    [userinfoDefaults setObject:[NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterMediumStyle] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_LASTUPDATE];
    [userinfoDefaults synchronize];
}

+(void)saveUserInfo:(NSDictionary *)userInfo
{
    NSUserDefaults *userinfoDefaults = [NSUserDefaults standardUserDefaults];
    [userinfoDefaults setObject:[userInfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_ID] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_ID];
    [userinfoDefaults setObject:[userInfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_USERNAME] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_USERNAME];
    [userinfoDefaults setObject:[userInfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_FULL_NAME] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_FULL_NAME];
    [userinfoDefaults setObject:[userInfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_PROFILE_PICTURE] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_PROFILE_PICTURE];
    [userinfoDefaults setObject:[userInfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_MEDIA] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_MEDIA];
    [userinfoDefaults setObject:[userInfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWED_BY] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWED_BY];
    [userinfoDefaults setObject:[userInfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWS] forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWS];
    [userinfoDefaults synchronize];
}

+(void)deleteUserDefaults{
    NSUserDefaults *userinfoDefaults = [NSUserDefaults standardUserDefaults];
    [userinfoDefaults setObject:nil forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_TOKEN];
    [userinfoDefaults setObject:nil forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_ID];
    [userinfoDefaults setObject:nil forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_USERNAME];
    [userinfoDefaults setObject:nil forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_FULL_NAME];
    [userinfoDefaults setObject:nil forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_PROFILE_PICTURE];
    [userinfoDefaults setObject:nil forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_MEDIA];
    [userinfoDefaults setObject:nil forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWED_BY];
    [userinfoDefaults setObject:nil forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWS];
    [userinfoDefaults setObject:nil forKey:INSTAFRIENDS_USER_DEFAULTS_KEY_LASTUPDATE];
    [userinfoDefaults synchronize];
}

+(BOOL)isUserLoggedIn
{
    if([[self getToken] length] == 0){
        return NO;
    }
    return YES;
}

+(BOOL)doesItHasInfo
{
    if([[self getLastUpdate] length] == 0){
        return NO;
    }
    return YES;
}


+(NSString *) getProfilePicture{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    return [userinfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_PROFILE_PICTURE];
}

+(NSString *) getUsername{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    return [userinfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_USERNAME];
}

+(NSString *) getID{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    return [userinfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_ID];
}

+(NSString *) getToken{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    return [userinfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_TOKEN];
}

+(NSString *) getFullName{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    return [userinfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_FULL_NAME];
}

+(NSString *) getLastUpdate{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    return [userinfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_LASTUPDATE];
}

+(NSString *) getFollowedBy{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    return [userinfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWED_BY];
}

+(NSString *)  getFollows{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    return [userinfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_FOLLOWS];
}

+(NSString *)  getMedia{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    return [userinfo objectForKey:INSTAFRIENDS_USER_DEFAULTS_KEY_COUNT_MEDIA];
}



@end
