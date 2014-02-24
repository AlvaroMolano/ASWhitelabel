//
//  ASWhitelabelViewController.m
//
//
//  Created by Daniel Bowden on 20/02/2014.
//
//

#import "ASWhitelabelViewController.h"

NS_ENUM(NSInteger, ASAlertViewType)
{
    ASAlertViewTypeError
};

@interface ASWhitelabelViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, weak) id<ASWhitelabelDelegate> delegate;
@property (nonatomic, assign) NSInteger venueID;

- (void)loadWhitelabel;
- (void)exitWhiteLabel;
- (NSURL *)environmentURL;

@end

NSString static *const kASWhitelabelUrlQA = @"https://qa.whitelabel.airservice.com";
NSString static *const kASWhitelabelUrlStaging = @"https://staging.whitelabel.airservice.com";
NSString static *const kASWhitelabelUrl = @"https://whitelabel.airservice.com";


@implementation ASWhitelabelViewController

- (id)initWithVenueID:(NSInteger)vID delegate:(id<ASWhitelabelDelegate>)dlg
{
    self = [super init];
    
    if (self)
    {
        _venueID = vID;
        _delegate = dlg;
        _environment = ASEnvironmentProduction;
    }
    
    return self;
}

- (void)loadView
{
    self.view = self.webView;
    [self loadWhitelabel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.webView stopLoading];
    self.webView.delegate = nil;
}

#pragma mark - Private Methods

- (void)loadWhitelabel
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[self environmentURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:25.0];
    [self.webView loadRequest:request];
}

- (void)exitWhiteLabel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ASWhitelabelViewControllerDidRequestExit:)])
    {
        [self.delegate ASWhitelabelViewControllerDidRequestExit:self];
    }
}

- (NSURL *)environmentURL
{
    //    NSString *urlString = [NSString stringWithFormat:@"%@/%d", kASWhitelabelBaseURL, self.venueID]; TODO: Implement specific venueID url when this is available
    
    switch (self.environment)
    {
        case ASEnvironmentProduction:
            return [NSURL URLWithString:kASWhitelabelUrl];
            break;
        case ASEnvironmentStaging:
            return [NSURL URLWithString:kASWhitelabelUrlStaging];
            break;
        case ASEnvironmentQA:
            return [NSURL URLWithString:kASWhitelabelUrlQA];
            break;
            
        default:
            return [NSURL URLWithString:kASWhitelabelUrl];
            break;
    }
}

- (UIWebView *)webView
{
    if(!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    return _webView;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] absoluteString] isEqualToString:@"AS://exit"])
    {
        [self exitWhiteLabel];
        return NO;
    }
    
    return YES;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"There was a problem loading AirService" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Retry", nil];
    alert.tag = ASAlertViewTypeError;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ASAlertViewTypeError)
    {
        if (buttonIndex == 0)
        {
            [self exitWhiteLabel];
        }
        else
        {
            [self loadWhitelabel];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

@implementation UINavigationController (StatusBarStyle)

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
