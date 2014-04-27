//
//  InstafriendsDashbordViewController.m
//  instafriends
//
//  Created by Daniel Camargo on 08/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsDashbordViewController.h"
#import "InstafriendsUserDefaults.h"
#import "InstafriendsConstants.h"
#import "UIImageView+WebCache.h"
#import "Instagramer+DataBase.h"
#import "InstafriendsNormalButtonSetup.h"

@interface InstafriendsDashbordViewController ()

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

@implementation InstafriendsDashbordViewController

@synthesize friendsList = _friendsList;
@synthesize fansList = _fansList;
@synthesize followingsList = _followingsList;
@synthesize labelUserCounts = _labelUserCounts;
@synthesize buttonUpdate = _buttonUpdate;
@synthesize imageViewProfilePicture = _imageViewProfilePicture;
@synthesize labelUsername = _labelUsername;
@synthesize labelFullName = _labelFullName;
@synthesize labelLastUpdate = _labelLastUpdate;
@synthesize instafriendsDatabase = _instafriendsDatabase;
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

- (void)setInstafriendsDatabase:(UIManagedDocument *)instafriendsDatabase
{
    if (_instafriendsDatabase != instafriendsDatabase) {
        _instafriendsDatabase = instafriendsDatabase;
        [self useDocument];
    }
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.instafriendsDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [self.instafriendsDatabase saveToURL:self.instafriendsDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self updateCount];
            
        }];
    } else if (self.instafriendsDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.instafriendsDatabase openWithCompletionHandler:^(BOOL success) {
            [self updateCount];
        }];
    } else if (self.instafriendsDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self updateCount];
    }
    
}

-(void)updateCount{
    
    [self.labelUserCounts setText:[NSString stringWithFormat:@"You have %@ photos. You follow %@ and are followed by %@ instagramers.", [InstafriendsUserDefaults getMedia], [InstafriendsUserDefaults getFollows], [InstafriendsUserDefaults getFollowedBy]]];
    [self.labelFriendsCount setText:[NSString stringWithFormat:@"%d",[Instagramer countResultsOfFriendswithContext:self.instafriendsDatabase.managedObjectContext]]];
    [self.labelFansCount setText:[NSString stringWithFormat:@"%d",[Instagramer countResultsOfFanswithContext:self.instafriendsDatabase.managedObjectContext]]];
    [self.labelFollowingCount setText:[NSString stringWithFormat:@"%d",[Instagramer countResultsOfFollowingswithContext:self.instafriendsDatabase.managedObjectContext]]];
}


-(void)checkIfItHasTheUserHasSomeInfo
{
    if(![InstafriendsUserDefaults doesItHasInfo]){
        [self.labelLastUpdate setText:@"Please update your info"];
        self.viewWithButtons.hidden = YES;
    } else{
        self.labelLastUpdate.text = [NSString stringWithFormat:@"Last update %@", [InstafriendsUserDefaults getLastUpdate]];
        self.viewWithButtons.hidden = NO;
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

- (void)viewWillAppear:(BOOL)animated{
    if (!self.instafriendsDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:INSTAFRIENDS_DATABASE_NAME];
        self.instafriendsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }else{
        [self updateCount];
    }
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
    if ([segue.identifier isEqualToString:@"Show Fans"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationship = %@", INSTAFRIENDS_RELATION_FAN];
        [segue.destinationViewController setTitle:[NSString stringWithFormat:@"Fans (%@)", self.labelFansCount.text]];
        [segue.destinationViewController setPredicate:predicate];
        [segue.destinationViewController setInstafriendsDatabase:self.instafriendsDatabase];
    } else if ([segue.identifier isEqualToString:@"Show Friends"]) {
        [segue.destinationViewController setTitle:[NSString stringWithFormat:@"Friends (%@)", self.labelFriendsCount.text]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationship = %@", INSTAFRIENDS_RELATION_FRIEND];
        [segue.destinationViewController setPredicate:predicate];
        [segue.destinationViewController setInstafriendsDatabase:self.instafriendsDatabase];
    } else if ([segue.identifier isEqualToString:@"Show Followings"]) {
        [segue.destinationViewController setTitle:[NSString stringWithFormat:@"Followings (%@)", self.labelFollowingCount.text]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationship = %@", INSTAFRIENDS_RELATION_FOLLOWING];
        [segue.destinationViewController setPredicate:predicate];
        [segue.destinationViewController setInstafriendsDatabase:self.instafriendsDatabase];
    } else if ([segue.identifier isEqualToString:@"Brain Modal"]) {
        [segue.destinationViewController setInstafriendsDatabase:self.instafriendsDatabase];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)logOut:(id)sender {
    [Instagramer deleteAllObjectsWithContext:self.instafriendsDatabase.managedObjectContext];
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
