//
//  InstafriendsAuthWebView.m
//  instafriends
//
//  Created by Daniel Camargo on 08/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsAuthWebView.h"
#import "InstafriendsConstants.h"
#import "InstafriendsUserDefaults.h"
#import "InstafriendsInstagramFetcher.h"

@interface InstafriendsAuthWebView ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIWebView *webViewAuth;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation InstafriendsAuthWebView

@synthesize activityIndicator = _activityIndicator;
@synthesize navBar = _navBar;
@synthesize webViewAuth = _webViewAuth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webViewAuth.delegate = self;
    NSString *urlAddress = INSTAFRIENDS_AUTH_URL;
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
    [self.webViewAuth loadRequest:requestObj];
    
	UIButton *closeButton =  [UIButton buttonWithType: UIButtonTypeCustom];
    [closeButton setImage: [UIImage imageNamed: @"close.png"] forState: UIControlStateNormal];
    [closeButton addTarget: self action: @selector(close) forControlEvents: UIControlEventTouchUpInside];
	[closeButton setFrame: CGRectMake(0, 0, 32, 32)];
   
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Log in to Instagram"];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: closeButton];;
    item.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: closeButton];;
    [self.navBar pushNavigationItem:item animated:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    NSString *redirectUrl = @"http://inst.me";
    NSString *url = webView.request.URL.absoluteString;
    if ([[url lowercaseString] hasPrefix:[redirectUrl lowercaseString]]) {
        // Extract the token
        NSRange tokenRange = [[url lowercaseString] rangeOfString:@"#access_token="];
        if (tokenRange.location != NSNotFound) {
            // We have our token
            NSString* token = [url substringFromIndex:tokenRange.location + tokenRange.length];
            [self authenticated:token];
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Authorization failed"
                                                              message:@"Authorization failed!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicator startAnimating];
}


-(void) authenticated:(NSString *)token{
    NSDictionary *userInfo = [InstafriendsInstagramFetcher loadUserInfoByToken:token];
    [InstafriendsUserDefaults saveToken:token];
    if(userInfo){
        [InstafriendsUserDefaults saveUserInfo:userInfo];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setWebViewAuth:nil];
    [self setActivityIndicator:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)close {
    [self dismissModalViewControllerAnimated:YES];
}
@end
