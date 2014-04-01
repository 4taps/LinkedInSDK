//
//  VKDialog.m
//  WC
//
//  Created by Ilya Elovikov on 26.04.12.
//  Copyright (c) 2012 i.elovikov@gmail.com. All rights reserved.
//

#import "InLoginDialog.h"
#import "NSStringUrlParams.h"

#define WEB_VIEW_MARGIN_TOP 20
#define API_KEY_LENGTH 12
#define SECRET_KEY_LENGTH 16

@implementation InLoginDialog {
    OADataFetcher *fetcher;
}

@synthesize
splashLabel,
toolbar,
requestToken, accessToken, consumer;


- (id) init {
    self = [super init];
    
    __webView = [[UIWebView alloc] initWithFrame:self.frame];
    __webView.delegate = self;
    __webView.scalesPageToFit = YES;
    __webView.scrollView.bounces = false;
    
    [self setAutoresizesSubviews:NO];
    [self setClipsToBounds:YES];
    
    [self addSubview:__webView];
    
    return self;
}

- (void) clean {
    __webView.delegate = nil;
    __delegate  = nil;
    __webView   = nil;
    __loginURL  = nil;
    splashLabel = nil;
    toolbar     = nil;
}

-(void) reinitWebView {
    
}

-(id) initWithDelegate:(id <InLoginDialogDelegate>) theDelegate
{
    self = [self init];
    
    __delegate = theDelegate;
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Web View Delegate

- (BOOL)webView:(UIWebView *)aWbView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *URL = [request URL];
    
    // Пользователь нажал Отмена в веб-форме
    NSDictionary *params = [[URL query] parseURLParams];
    int cancel = [[params valueForKey:@"cancel"] intValue];
    if( cancel == 1 ){
        if (__delegate) {
            [__delegate inDialogNotLogin:NO];
        }
        [self clean];
        [self removeFromSuperview];
        
        return NO;        
    }
    
	NSString *urlString = URL.absoluteString;
    
    BOOL requestForCallbackURL = ([urlString rangeOfString:_linkedInCallbackURL].location != NSNotFound);
    if ( requestForCallbackURL )
    {
        BOOL userAllowedAccess = ([urlString rangeOfString:@"user_refused"].location == NSNotFound);
        if ( userAllowedAccess )
        {
            [requestToken setVerifierWithUrl:URL];
            [self accessTokenFromProvider];
        }
        else
        {
            if (__delegate) {
                [__delegate inDialogNotLogin:NO];
            }
            [self clean];
            [self removeFromSuperview];
        }
    }
    else
    {
        // Case (a) or (b), so ignore it
    }
	return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {

    [self hideSplash];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"[WebView] Error: %@", [error localizedDescription]);
    
    NSDictionary *userInfo = [error userInfo];
    NSURL *errorURL = [userInfo valueForKey:@"NSErrorFailingURLKey"];
    BOOL isHdLinked = [errorURL.scheme isEqual:@"hdlinked"];
    
    if ([error code] == NSURLErrorCancelled || isHdLinked) {
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error")
                                                    message:NSLocalizedString(@"Unable to connect to linkedin.com", @"Unable to connect to linkedin.com")
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    if (__delegate) {
        [__delegate inDialogNotLogin:NO];
    }
    [self clean];
    [self removeFromSuperview];
}

#pragma mark - OADataFetcher

//
// OAuth step 1b:
//
// When this method is called it means we have successfully received a request token.
// We then show a webView that sends the user to the LinkedIn login page.
// The request token is added as a parameter to the url of the login page.
// LinkedIn reads the token on their end to know which app the user is granting access to.
//
- (void)requestTokenResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    if (ticket.didSucceed == NO)
        return;
    
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    [self allowUserToLogin];
}

- (void)requestTokenResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
    
    if (__delegate) {
        [__delegate inDialogNotLogin:NO];
    }
    [self clean];
    [self removeFromSuperview];
}

// Authorization finished

- (void)accessTokenResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    BOOL problem = ([responseBody rangeOfString:@"oauth_problem"].location != NSNotFound);
    if ( problem )
    {
        NSLog(@"Request access token failed.");
        NSLog(@"%@",responseBody);
        
        if (__delegate) {
            [__delegate inDialogNotLogin:NO];
        }
    }
    else
    {
        accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        
        if (__delegate) {
            [__delegate inDialogLogin];
        }
    }
    
    [self clean];
    [self removeFromSuperview];
}

- (void)accessTokenResult:(OAServiceTicket *)ticket didFail:(NSError *)error {
    NSLog(@"%@",[error description]);
}

#pragma mark -
#pragma mark - Methods

//
// OAuth step 1a:
//
// The first step in the the OAuth process to make a request for a "request token".
// Yes it's confusing that the work request is mentioned twice like that, but it is whats happening.
//
- (void)requestTokenFromProvider
{
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:requestTokenURL
                                     consumer:consumer
                                        token:nil
                                     callback:_linkedInCallbackURL
                            signatureProvider:nil];
    
    [request setHTTPMethod:@"POST"];
    
    OARequestParameter * scopeParameter=[OARequestParameter requestParameter:@"scope" value:@"r_fullprofile r_network rw_nus"];
    
    [request setParameters:[NSArray arrayWithObject:scopeParameter]];
    
    fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenResult:didFinish:)
                  didFailSelector:@selector(requestTokenResult:didFail:)];
}

//
// OAuth step 2:
//
// Show the user a browser displaying the LinkedIn login page.
// They type username/password and this is how they permit us to access their data
// We use a UIWebView for this.
//
// Sending the token information is required, but in this one case OAuth requires us
// to send URL query parameters instead of putting the token in the HTTP Authorization
// header as we do in all other cases.
//
- (void)allowUserToLogin
{
    
    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@",
                                       _userLoginURLString, requestToken.key];
    
    userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL: userLoginURL];
    [__webView loadRequest:request];
}

//
// OAuth step 4:
//
- (void)accessTokenFromProvider
{
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:accessTokenURL
                                     consumer:consumer
                                        token:requestToken
                                     callback:nil
                            signatureProvider:nil];
    
    [request setHTTPMethod:@"POST"];
    fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenResult:didFinish:)
                  didFailSelector:@selector(accessTokenResult:didFail:)];
}

- (void)tryLogin
{
    if ([_apiKey length] < API_KEY_LENGTH || [_secretKey length] < SECRET_KEY_LENGTH)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"OAuth Starter Kit"
                              message: @"You must add your apikey and secretkey. See the project file readme.txt"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        if (__delegate) {
            [__delegate inDialogNotLogin:NO];
        }
        [self clean];
        [self removeFromSuperview];
    }
    
    [self requestTokenFromProvider];
}

- (void) show {
    
    requestTokenURL = [NSURL URLWithString:_requestTokenURLString];
    accessTokenURL  = [NSURL URLWithString:_accessTokenURLString];
    userLoginURL    = [NSURL URLWithString:_userLoginURLString];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.frame  = CGRectMake(0, WEB_VIEW_MARGIN_TOP, screenSize.width, screenSize.height - WEB_VIEW_MARGIN_TOP);
    
    __webView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - WEB_VIEW_MARGIN_TOP);
    
    [self showSplash];
    
    [window addSubview:self];
    
    [self tryLogin];

}

- (void) showSplash {
    //индикатор загрузки, который показывается при первом входе на экран радара
    splashLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 200, 218, 30)];
    [splashLabel setText: NSLocalizedString(@"Connecting to linkedin.com...", @"Connecting to linkedin.com...")];
    [splashLabel setTextAlignment:NSTextAlignmentCenter];
    [splashLabel setBackgroundColor:[UIColor clearColor]];
    [splashLabel setTextColor:[UIColor grayColor]];
    [splashLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [splashLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:splashLabel];
    
    UIActivityIndicatorView *splashIndcator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [splashIndcator setFrame:CGRectMake(0, 4, 20, 20)];
    [splashIndcator startAnimating];
    [splashLabel addSubview:splashIndcator];
}

-(void) hideSplash {
    [splashLabel removeFromSuperview];
}

-(void) hideToolbar {
//    [toolbar removeFromSuperview];
}

-(void)webViewCancel {
    if (__delegate && [__delegate respondsToSelector:@selector(inDialogNotLogin:)]) {
        [__delegate inDialogNotLogin:YES];
    }
    
    [self clean];
    [self removeFromSuperview];

    return;
}

@end
