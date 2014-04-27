//
//  InstafriendsInstagramerCell.m
//  instafriends
//
//  Created by Daniel Camargo on 01/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsInstagramerCell.h"
#import "InstafriendsConstants.h"
#import "Instagramer.h"
#import "UIImageView+WebCache.h"
#import "Instagramer+DataBase.h"
#import "InstafriendsInstagramFetcher.h"
#import "InstafriendsUserDefaults.h"

@interface InstafriendsInstagramerCell()
-(void)setupButton;
@end

@implementation InstafriendsInstagramerCell
@synthesize labelFullName = _labelFullName;
@synthesize labelUsername = _labelUsername;
@synthesize imageViewProfilePicture = _imageViewProfilePicture;
@synthesize buttonView = _buttonView;
@synthesize instagramer = _instagramer;
@synthesize indexPath = _indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)debug:(id)sender {
    NSLog(@"instagramer:%@", self.instagramer);
}

-(void)setup{
    self.labelUsername.text = self.instagramer.username;
    self.labelFullName.text = self.instagramer.fullName;
    [self.imageViewProfilePicture setImageWithURL:[NSURL URLWithString:self.instagramer.profilePicture]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setupButton];
}

-(void)setupButton{
    UIButton *button;
    UIImage *buttonBackground;
    NSString *buttonTitle;
    if([self.instagramer.relationship isEqualToString:INSTAFRIENDS_RELATION_FAN]){
       buttonBackground = [UIImage imageNamed:@"follow.png"];
        buttonTitle = @"follow";
    }else if([self.instagramer.relationship isEqualToString:INSTAFRIENDS_RELATION_FRIEND] ||
             [self.instagramer.relationship isEqualToString:INSTAFRIENDS_RELATION_FOLLOWING]){
        buttonBackground = [UIImage imageNamed:@"unfollow.png"];
        buttonTitle = @"unfollow";
    }
    float w = buttonBackground.size.width / 2, h = buttonBackground.size.height / 2;
    UIImage *stretch = [buttonBackground stretchableImageWithLeftCapWidth:w topCapHeight:h];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 30);
    [button setBackgroundImage:stretch forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doFollowUnfollow:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = self.indexPath.row;
    [self.buttonView addSubview:button];
}

- (void) doFollowUnfollow:(UIButton*) sender{
    [sender removeFromSuperview];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
    [self.buttonView addSubview:activityIndicator];
    dispatch_queue_t fetchQ = dispatch_queue_create("Instagram fetcher", NULL);
    NSString *token = [InstafriendsUserDefaults getToken];
    dispatch_async(fetchQ, ^{
        [self.instagramer.managedObjectContext performBlock:^{
            NSString *relationship;
            if([self.instagramer.relationship isEqualToString:INSTAFRIENDS_RELATION_FAN]){
                relationship = INSTAFRIENDS_RELATION_FRIEND;
                [InstafriendsInstagramFetcher followUserID:self.instagramer.id usingTheToken:token];
            } else if([self.instagramer.relationship isEqualToString:INSTAFRIENDS_RELATION_FRIEND]){
                relationship = INSTAFRIENDS_RELATION_FAN;
                [InstafriendsInstagramFetcher unfollowUserID:self.instagramer.id usingTheToken:token];
            }else if([self.instagramer.relationship isEqualToString:INSTAFRIENDS_RELATION_FOLLOWING]){
                relationship = INSTAFRIENDS_RELATION_NOTHING;
                [InstafriendsInstagramFetcher unfollowUserID:self.instagramer.id usingTheToken:token];
            }
            [Instagramer instagramerChange:self.instagramer toRelation:relationship];
        }];
        [self setupButton];
    });
    dispatch_release(fetchQ);
}

@end
