//
//  InstafriendsBrainViewController.h
//  instafriends
//
//  Created by Daniel Camargo on 01/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstafriendsInstagramFetcher.h"

@protocol updateUsersList;


@interface InstafriendsBrainViewController : UIViewController <InstafriendsInstagramFetcherListenner>
@property (nonatomic, strong) UIManagedDocument *instafriendsDatabase;
- (void)setInstafriendsDatabase:(UIManagedDocument *)instafriendsDatabase;
@property (nonatomic, assign) id<updateUsersList> delegate;
@end

@protocol updateUsersList <NSObject>

-(void) updateFriendsList: (NSArray *) list;
-(void) updateFansList: (NSArray *) list;
-(void) updateFollowingsList: (NSArray *) list;
-(void) reloadInfo;

@end