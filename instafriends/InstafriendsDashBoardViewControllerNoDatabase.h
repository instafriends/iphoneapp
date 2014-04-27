//
//  InstafriendsDashBoardViewControllerNoDatabase.h
//  instafriends
//
//  Created by Daniel Camargo on 04/10/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstafriendsBrainViewController.h"

@interface InstafriendsDashBoardViewControllerNoDatabase : UIViewController <updateUsersList> 

-(void) getFriendsList: (NSArray *) list ;
-(void) getFansList: (NSArray *) list ;
-(void) getFollowingsList: (NSArray *) list ;

@end