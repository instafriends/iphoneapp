//
//  InstafriendsCell.m
//  instafriends
//
//  Created by Daniel Camargo on 04/10/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsCell.h"
#import "InstafriendsConstants.h"
#import "UIImageView+WebCache.h"
#import "InstafriendsUserDefaults.h"
#import "InstafriendsInstagramFetcher.h"

@interface InstafriendsCell()
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelFullName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfilePicture;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
 
@end

@implementation InstafriendsCell

@synthesize labelUsername = _labelUsername;
@synthesize labelFullName = _labelFullName;
@synthesize buttonView = _buttonView;
@synthesize imageViewProfilePicture = _imageViewProfilePicture;
@synthesize user = _user;
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


-(void)setup{
    self.labelUsername.text = [self.user objectForKey:@"username"];
    self.labelFullName.text = [self.user objectForKey:@"fullName"];
    [self.imageViewProfilePicture setImageWithURL:[NSURL URLWithString:[self.user objectForKey:@"profile_picture"]]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setupButton];
}

-(void)setupButton{
    UIButton *button;
    UIImage *buttonBackground;
    NSString *buttonTitle;
    if([[self.user objectForKey:@"relationship"] isEqualToString:INSTAFRIENDS_RELATION_FAN] ||
       [[self.user objectForKey:@"relationship"] isEqualToString:INSTAFRIENDS_RELATION_NOTHING] ){
        buttonBackground = [UIImage imageNamed:@"follow.png"];
        buttonTitle = @"follow";
    }else if([[self.user objectForKey:@"relationship"] isEqualToString:INSTAFRIENDS_RELATION_FOLLOWING] ||
             [[self.user objectForKey:@"relationship"] isEqualToString:INSTAFRIENDS_RELATION_FRIEND]){
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
    NSString *token = [InstafriendsUserDefaults getToken];
    NSString *relationship;
    NSString *relationshipActual = [self.user objectForKey:@"relationship"];
    if([[self.user objectForKey:@"relationship"] isEqualToString:INSTAFRIENDS_RELATION_FAN]){
        relationship = INSTAFRIENDS_RELATION_FRIEND;
    } else if([[self.user objectForKey:@"relationship"] isEqualToString:INSTAFRIENDS_RELATION_FRIEND]){
        relationship = INSTAFRIENDS_RELATION_FAN;
    } else if([[self.user objectForKey:@"relationship"] isEqualToString:INSTAFRIENDS_RELATION_FOLLOWING]){
        relationship = INSTAFRIENDS_RELATION_NOTHING;
    } else if([[self.user objectForKey:@"relationship"] isEqualToString:INSTAFRIENDS_RELATION_NOTHING]){
        relationship = INSTAFRIENDS_RELATION_FOLLOWING;
    }
    [self.user setObject:relationship forKey:@"relationship"];
    [self setupButton];
    dispatch_queue_t fetchQ = dispatch_queue_create("Instagram fetcher", NULL);
    dispatch_async(fetchQ, ^{
        if([relationshipActual isEqualToString:INSTAFRIENDS_RELATION_FAN]){
            [InstafriendsInstagramFetcher followUserID:[self.user objectForKey:@"id"] usingTheToken:token];
        } else if([relationshipActual isEqualToString:INSTAFRIENDS_RELATION_FRIEND]){
            [InstafriendsInstagramFetcher unfollowUserID:[self.user objectForKey:@"id"] usingTheToken:token];
        } else if([relationshipActual isEqualToString:INSTAFRIENDS_RELATION_FOLLOWING]){
            [InstafriendsInstagramFetcher unfollowUserID:[self.user objectForKey:@"id"] usingTheToken:token];
        }else if([relationshipActual isEqualToString:INSTAFRIENDS_RELATION_NOTHING]){
            [InstafriendsInstagramFetcher followUserID:[self.user objectForKey:@"id"] usingTheToken:token];
        }
        
    });
    dispatch_release(fetchQ);
}

@end
