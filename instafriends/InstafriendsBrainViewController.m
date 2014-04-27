//
//  InstafriendsBrainViewController.m
//  instafriends
//
//  Created by Daniel Camargo on 01/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsBrainViewController.h"
#import "Instagramer+DataBase.h"
#import "InstafriendsConstants.h"
#import "InstafriendsUserDefaults.h"
#import "InstafriendsNormalButtonSetup.h"

@interface InstafriendsBrainViewController () <InstafriendsInstagramFetcherListenner>
@property (strong, nonatomic) IBOutlet UILabel *labelStatus;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)itIsDone:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonClose;
@property int lastCount;

@property (nonatomic,retain) NSMutableArray *friendsList;
@property (nonatomic,retain) NSMutableArray *fansList;
@property (nonatomic,retain) NSMutableArray *followingsList;

@end

@implementation InstafriendsBrainViewController
@synthesize delegate = _delegate;
@synthesize friendsList = _friendsList;
@synthesize fansList = _fansList;
@synthesize followingsList = _followingsList;

@synthesize labelStatus = _labelStatus;
@synthesize lastCount = _lastCount;
@synthesize instafriendsDatabase = _instafriendsDatabase;
@synthesize activityIndicator = _activityIndicator;
@synthesize buttonClose = _buttonClose;
/*
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
            [self fetchInstagramDataIntoDocument:self.instafriendsDatabase];
            
        }];
    } else if (self.instafriendsDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.instafriendsDatabase openWithCompletionHandler:^(BOOL success) {
            [self fetchInstagramDataIntoDocument:self.instafriendsDatabase];
        }];
    } else if (self.instafriendsDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self fetchInstagramDataIntoDocument:self.instafriendsDatabase];
    }
}*/

-(void)showTheInstagramFetcherStatus:(NSString *)statusLabel andCount:(int)count {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(count == 0){
            self.lastCount = 0;
        }
        if( self.lastCount < count ){
            self.labelStatus.text = [NSString stringWithFormat:statusLabel, count];
            self.lastCount = count;
        }
    });
}
- (void)startProcess
{
    NSString *token = [InstafriendsUserDefaults getToken];
    NSString *userID = [InstafriendsUserDefaults getID];
    dispatch_queue_t fetchQ = dispatch_queue_create("Instagram fetcher", NULL);
    InstafriendsInstagramFetcher *instafriendsInstagramFetcher = [[InstafriendsInstagramFetcher alloc]init];
    instafriendsInstagramFetcher.delegate = self;
    dispatch_async(fetchQ, ^{
        NSDictionary *userInfo = [InstafriendsInstagramFetcher loadUserInfoByToken:token];
        [InstafriendsUserDefaults saveToken:token];
        if(userInfo){
            [InstafriendsUserDefaults saveUserInfo:userInfo];
        }
        self.followingsList = [[NSMutableArray alloc]init];
        self.fansList = [[NSMutableArray alloc]init];
        self.friendsList = [[NSMutableArray alloc]init];
        NSDictionary *instagramers = [instafriendsInstagramFetcher sortDatas:userID byToken:token];
        for (NSDictionary *username in instagramers) {
            id instagramerInfo = [instagramers objectForKey:username];
            NSString *relation = [instagramerInfo valueForKey:@"relationship"];
            if( [relation isEqualToString:@"following"] ){
                [self.followingsList addObject:instagramerInfo];
            }
            if( [relation isEqualToString:@"fan"] ){
                [self.fansList addObject:instagramerInfo];
            }
            if( [relation isEqualToString:@"friend"] ){
                [self.friendsList addObject:instagramerInfo];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate updateFriendsList:[NSArray arrayWithArray:self.friendsList]];
            [self.delegate updateFansList:[NSArray arrayWithArray:self.fansList]];
            [self.delegate updateFollowingsList:[NSArray arrayWithArray:self.followingsList]];
            [InstafriendsUserDefaults saveLastUpdate];
            self.labelStatus.text = @"Done! You can close this window.";
            [self.activityIndicator stopAnimating];
            [InstafriendsNormalButtonSetup setupButton:self.buttonClose];
            self.buttonClose.hidden = NO;
            [self.delegate reloadInfo];
        });
    });
    dispatch_release(fetchQ);
}
/*
- (void)fetchInstagramDataIntoDocument:(UIManagedDocument *)document
{
    NSString *token = [InstafriendsUserDefaults getToken];
    NSString *userID = [InstafriendsUserDefaults getID];
    dispatch_queue_t fetchQ = dispatch_queue_create("Instagram fetcher", NULL);
    InstafriendsInstagramFetcher *instafriendsInstagramFetcher = [[InstafriendsInstagramFetcher alloc]init];
    instafriendsInstagramFetcher.delegate = self;
    dispatch_async(fetchQ, ^{
        NSDictionary *userInfo = [InstafriendsInstagramFetcher loadUserInfoByToken:token];
        [InstafriendsUserDefaults saveToken:token];
        if(userInfo){
            [InstafriendsUserDefaults saveUserInfo:userInfo];
        }
        NSDictionary *users = [instafriendsInstagramFetcher sortDatas:userID byToken:token];
        self.labelStatus.text = @"Updating the database. Please wait.";
        [document.managedObjectContext performBlock:^{
            [Instagramer deleteAllObjectsWithContext:document.managedObjectContext];
            [Instagramer addInstagramer:users inManagedObjectContext:document.managedObjectContext];
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            self.labelStatus.text = @"Done! You can close this window.";
            [self.activityIndicator stopAnimating];
            [InstafriendsNormalButtonSetup setupButton:self.buttonClose];
            self.buttonClose.hidden = NO;
        }];
        [InstafriendsUserDefaults saveLastUpdate];
    });
    dispatch_release(fetchQ);
}

-(void)setup
{
    if (!self.instafriendsDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:INSTAFRIENDS_DATABASE_NAME];
        self.instafriendsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}
*/
- (void)viewDidLoad
{
    [self startProcess];
    [super viewDidLoad];
    self.buttonClose.hidden = YES;
    [self setBackGround];
    //[self setup];
}

- (void)viewDidUnload
{
    
    //[self setInstafriendsDatabase:nil];
    [self setLabelStatus:nil];
    [self setActivityIndicator:nil];
    [self setButtonClose:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)itIsDone:(id)sender {
     [self dismissModalViewControllerAnimated:YES];
}

-(void)setBackGround
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.png"] drawInRect:self.view.bounds];
    UIImage *imageBG = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:imageBG];
}

@end
