//
//  InstafriendsCell.h
//  instafriends
//
//  Created by Daniel Camargo on 04/10/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstafriendsCell : UITableViewCell
@property (strong, nonatomic)NSMutableDictionary * user;
@property (strong, nonatomic) NSIndexPath *indexPath;

-(void)setup;
-(void)doFollowUnfollow:( UIButton *)sender;
@end
