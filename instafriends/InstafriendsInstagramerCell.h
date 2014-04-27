//
//  InstafriendsInstagramerCell.h
//  instafriends
//
//  Created by Daniel Camargo on 01/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Instagramer;

@interface InstafriendsInstagramerCell : UITableViewCell

@property (strong, nonatomic) Instagramer *instagramer;
@property (strong, nonatomic) IBOutlet UILabel *labelFullName;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePicture;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) NSIndexPath *indexPath;
- (IBAction)debug:(id)sender;

-(void)setup;
-(void)doFollowUnfollow:( UIButton *)sender;

@end
