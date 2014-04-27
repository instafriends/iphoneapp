//
//  InstafriendsIntroViewController.m
//  instafriends
//
//  Created by Daniel Camargo on 01/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsIntroViewController.h"
#import "InstafriendsConstants.h"
#import "InstafriendsInstagramFetcher.h"
#import "InstafriendsUserDefaults.h"
#import "InstafriendsNormalButtonSetup.h"
#import "IsThereInternet.h"

@interface InstafriendsIntroViewController ()

@property (strong, nonatomic) IBOutlet UIButton *buttonAuth;

@property (strong, nonatomic) IBOutlet UILabel *labelWelcome;

@property (strong, nonatomic) IBOutlet UILabel *labelHeadLine;

@property (strong, nonatomic) IBOutlet UIButton *buttonShowDashboard;

@end

@implementation InstafriendsIntroViewController
@synthesize buttonAuth;
@synthesize labelWelcome;
@synthesize labelHeadLine;
@synthesize buttonShowDashboard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Instafriends";
    [self setBackGround];
    [InstafriendsNormalButtonSetup setupButton:self.buttonAuth];
    [InstafriendsNormalButtonSetup setupButton:self.buttonShowDashboard];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [IsThereInternet checkInternetConnection];
    [self controlTheButtons];
}


-(void)controlTheButtons
{
    BOOL isLogged = [InstafriendsUserDefaults isUserLoggedIn];
    self.buttonAuth.hidden = isLogged;
    self.buttonShowDashboard.hidden = !isLogged;
    if(isLogged){
        [self.labelWelcome setText:@"Hello,"];
        [self.labelHeadLine setText:[NSString stringWithFormat:@"@%@", [InstafriendsUserDefaults getUsername]]];
    } else {
        [self.labelWelcome setText:@"Welcome!"];
        [self.labelHeadLine setText:@"Please sign in with Instagram."];
    }
	UIButton *infoButton =  [UIButton buttonWithType: UIButtonTypeCustom];
    [infoButton setImage: [UIImage imageNamed: @"info.png"] forState: UIControlStateNormal];
    [infoButton addTarget: self action: @selector(moreAbout) forControlEvents: UIControlEventTouchUpInside];
	[infoButton setFrame: CGRectMake(0, 0, 32, 32)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: infoButton];
}

-(void)moreAbout
{
    [self performSegueWithIdentifier:@"More About" sender:self];
}

- (void)viewDidUnload
{
    [self setButtonAuth:nil];
    [self setButtonShowDashboard:nil];
    [self setLabelWelcome:nil];
    [self setLabelHeadLine:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)userInfoTemp:(id)sender {
    [self performSegueWithIdentifier:@"Show Dashboard" sender:self];
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
