//
//  InstafriendsMoreViewController.m
//  instafriends
//
//  Created by Daniel Camargo on 10/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsMoreViewController.h"
#import "InstafriendsConstants.h"
#import "InstafriendsNormalButtonSetup.h"

@interface InstafriendsMoreViewController ()
@property (strong, nonatomic) IBOutlet UIButton *buttonRate;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

@property (strong, nonatomic) IBOutlet UIWebView *helpWebView;

@end

@implementation InstafriendsMoreViewController
@synthesize buttonRate = _buttonRate;
@synthesize navBar = _navBar;
@synthesize helpWebView = _helpWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)rateApp:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:INSTAFRIENDS_RATE_URL]];
}
- (void)close
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //[self.activityIndicator startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [InstafriendsNormalButtonSetup setupButton:self.buttonRate];
    self.helpWebView.delegate = self;
    NSString *urlAddress = @"http://inst.me/app/help.html";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    sharedCache = nil;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    [self.helpWebView loadRequest:requestObj];

	UIButton *closeButton =  [UIButton buttonWithType: UIButtonTypeCustom];
    [closeButton setImage: [UIImage imageNamed: @"close.png"] forState: UIControlStateNormal];
    [closeButton addTarget: self action: @selector(close) forControlEvents: UIControlEventTouchUpInside];
	[closeButton setFrame: CGRectMake(0, 0, 32, 32)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"More about"];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: closeButton];;
    item.hidesBackButton = YES;
    [self.navBar pushNavigationItem:item animated:NO];
}

- (void)viewDidUnload
{
    [self setHelpWebView:nil];
    [self setButtonRate:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
