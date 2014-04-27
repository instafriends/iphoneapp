//
//  InstafriendsDashbordViewController.m
//  instafriends
//
//  Created by Daniel Camargo on 08/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsDashBoardViewControllerNoDatabase.h"
#import "InstafriendsUserDefaults.h"
#import "InstafriendsConstants.h"
#import "UIImageView+WebCache.h"
#import "InstafriendsNormalButtonSetup.h"
#import "InstafriendInstagramersTableViewController.h"

@interface InstafriendsDashBoardViewControllerNoDatabase ()

@property (strong, nonatomic) IBOutlet UILabel *labelUserCounts;
@property (strong, nonatomic) IBOutlet UIButton *buttonUpdate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonLogout;
@property (strong, nonatomic) IBOutlet UIView *viewWithButtons;
@property (strong, nonatomic) IBOutlet UILabel *labelFriendsCount;
@property (strong, nonatomic) IBOutlet UILabel *labelFansCount;
@property (strong, nonatomic) IBOutlet UILabel *labelFollowingCount;

@property (nonatomic,retain) NSMutableArray *friendsList;
@property (nonatomic,retain) NSMutableArray *fansList;
@property (nonatomic,retain) NSMutableArray *followingsList;

- (IBAction)logOut:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UILabel *labelFullName;
@property (strong, nonatomic) IBOutlet UILabel *labelLastUpdate;


@end

@implementation InstafriendsDashBoardViewControllerNoDatabase

@synthesize friendsList = _friendsList;
@synthesize fansList = _fansList;
@synthesize followingsList = _followingsList;
@synthesize labelUserCounts = _labelUserCounts;
@synthesize buttonUpdate = _buttonUpdate;
@synthesize imageViewProfilePicture = _imageViewProfilePicture;
@synthesize labelUsername = _labelUsername;
@synthesize labelFullName = _labelFullName;
@synthesize labelLastUpdate = _labelLastUpdate;

@synthesize buttonLogout = _buttonLogout;
@synthesize viewWithButtons = _viewWithButtons;
@synthesize labelFriendsCount = _labelFriendsCount;
@synthesize labelFansCount = _labelFansCount;
@synthesize labelFollowingCount = _labelFollowingCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void)reloadInfo{
    [self updateCount];
    NSLog(@"reload");
}

-(void) updateFriendsList: (NSArray *) list{
    self.friendsList = nil;
    self.friendsList = [[NSMutableArray alloc]initWithArray:list];
}

-(void) updateFansList: (NSArray *) list{
    self.fansList = nil;
    self.fansList = [[NSMutableArray alloc]initWithArray:list];
}

-(void) updateFollowingsList: (NSArray *) list{
    self.followingsList = nil;
    self.followingsList = [[NSMutableArray alloc]initWithArray:list];
}


-(void)updateCount{
    [self.labelUserCounts setText:[NSString stringWithFormat:@"You have %@ photos. You follow %@ and are followed by %@ instagramers.", [InstafriendsUserDefaults getMedia], [InstafriendsUserDefaults getFollows], [InstafriendsUserDefaults getFollowedBy]]];
    [self.labelFriendsCount setText:[NSString stringWithFormat:@"%d", [self.friendsList count]]];
    [self.labelFansCount setText:[NSString stringWithFormat:@"%d",[self.fansList count]]];
    [self.labelFollowingCount setText:[NSString stringWithFormat:@"%d",[self.followingsList count]]];
}


-(void)checkIfItHasTheUserHasSomeInfo
{
    if(![InstafriendsUserDefaults doesItHasInfo]){
        [self.labelLastUpdate setText:@"Please update your info"];
    } else{
        self.labelLastUpdate.text = [NSString stringWithFormat:@"Last visit %@", [InstafriendsUserDefaults getLastUpdate]];
    }
    if( [self.friendsList count] > 0 || [self.followingsList count] > 0 || [self.fansList count] > 0 ){
        self.viewWithButtons.hidden = NO;
    } else {
        self.viewWithButtons.hidden = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackGround];
        self.labelUsername.text = [InstafriendsUserDefaults getUsername];
    self.labelFullName.text = [InstafriendsUserDefaults getFullName];
    [self.imageViewProfilePicture setImageWithURL:[NSURL URLWithString:[InstafriendsUserDefaults getProfilePicture]]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    UIButton *leftButtonItem =  [UIButton buttonWithType: UIButtonTypeCustom];
    [leftButtonItem setImage: [UIImage imageNamed: @"buttonBack.png"] forState: UIControlStateNormal];
    [leftButtonItem addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    [leftButtonItem setFrame: CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: leftButtonItem];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)showFriends:(id)sender {
    [self performSegueWithIdentifier:@"Friends" sender:sender];
}
- (IBAction)showFans:(id)sender {
    [self performSegueWithIdentifier:@"Fans" sender:sender];
}
- (IBAction)showFollowing:(id)sender {
    [self performSegueWithIdentifier:@"Followings" sender:sender];
}


- (void)viewWillAppear:(BOOL)animated{
   /* if (!self.instafriendsDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:INSTAFRIENDS_DATABASE_NAME];
        self.instafriendsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }else{
        [self updateCount];
    }*/
    [self checkIfItHasTheUserHasSomeInfo];
}

- (void)viewDidUnload
{
    [self setImageViewProfilePicture:nil];
    [self setLabelUsername:nil];
    [self setLabelFullName:nil];
    [self setLabelLastUpdate:nil];
    [self setButtonLogout:nil];
    [self setViewWithButtons:nil];
    [self setButtonUpdate:nil];
    [self setLabelUserCounts:nil];
    [self setLabelFriendsCount:nil];
    [self setLabelFansCount:nil];
    [self setLabelFollowingCount:nil];
    [super viewDidUnload];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Fans"]) {
        [segue.destinationViewController setTitle:[NSString stringWithFormat:@"Fans (%@)", self.labelFansCount.text]];
        [segue.destinationViewController setList:self.fansList];
    } else if ([segue.identifier isEqualToString:@"Friends"]) {
        [segue.destinationViewController setTitle:[NSString stringWithFormat:@"Friends (%@)", self.labelFriendsCount.text]];
        [segue.destinationViewController setList:self.friendsList];
    } else if ([segue.identifier isEqualToString:@"Followings"]) {
        [segue.destinationViewController setTitle:[NSString stringWithFormat:@"Followings (%@)", self.labelFollowingCount.text]];
        [segue.destinationViewController setList:self.followingsList];
    } else if ([segue.identifier isEqualToString:@"Brain Modal"]) {
        self.friendsList = nil;
        self.followingsList = nil;
        self.fansList = nil;
        [segue.destinationViewController setDelegate:self];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)logOut:(id)sender {
    [InstafriendsUserDefaults deleteUserDefaults];
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)setBackGround
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.png"] drawInRect:self.view.bounds];
    UIImage *imageBG = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:imageBG];
    self.viewWithButtons.backgroundColor = [UIColor colorWithPatternImage:imageBG];
}

@end
