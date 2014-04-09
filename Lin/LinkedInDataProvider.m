//
//  LinkedIn.m
//  OAuthStarterKit
//
//  Created by Ilya Elovikov on 28/03/14.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "LinkedInDataProvider.h"
#import "NSStringUrlParams.h"

#define kLinkedinAPIURL @"http://api.linkedin.com/v1/"
#define kLinkedinOAUTHURL @"https://api.linkedin.com/"
#define kLinkedinCallbackURL @"hdlinked://linkedin/oauth"

@implementation LinkedInDataProvider {
    InLoginDialog *_loginDialog;
    id<LInSessionDelegate> _delegate;
}

static LinkedInDataProvider *_instance;
+ (LinkedInDataProvider *)inststance {
    
    if (_instance == nil) {
        _instance = [LinkedInDataProvider new];
    }
    
    return _instance;
}

- (id)init {
    if (_instance) {
        self = _instance;
    } else {
        self = [super init];
        
        [self initLinkedInApi];
    }
    
    return self;
}

//
//  This api consumer data could move to a provider object
//  to allow easy switching between LinkedIn, Twitter, etc.
//
- (void)initLinkedInApi
{
    apikey    = LINKEDIN_API_KEY;
    secretkey = LINKEDIN_SECRET_KEY;
    
    consumer = [[OAConsumer alloc] initWithKey:apikey
                                        secret:secretkey
                                         realm:kLinkedinAPIURL];
    
    requestTokenURLString = [NSString stringWithFormat:@"%@%@", kLinkedinOAUTHURL, @"uas/oauth/requestToken"];
    accessTokenURLString  = [NSString stringWithFormat:@"%@%@", kLinkedinOAUTHURL, @"uas/oauth/accessToken"];
    userLoginURLString    = [NSString stringWithFormat:@"%@%@", kLinkedinOAUTHURL, @"uas/oauth/authorize"];
    linkedInCallbackURL   = kLinkedinCallbackURL;
}

- (void)authorizeWithDelegate: (id<LInSessionDelegate>)delegate {
    if ([self authorized]) {
        [delegate inDidLogin];
    }
    
    _delegate = delegate;
    
    _loginDialog = [[InLoginDialog alloc] initWithDelegate:self];
    [_loginDialog setApiKey:apikey];
    [_loginDialog setSecretKey:secretkey];
    [_loginDialog setConsumer:consumer];
    [_loginDialog setRequestTokenURLString:requestTokenURLString];
    [_loginDialog setAccessTokenURLString:accessTokenURLString];
    [_loginDialog setUserLoginURLString:userLoginURLString];
    [_loginDialog setLinkedInCallbackURL:linkedInCallbackURL];
    [_loginDialog show];
}

- (BOOL)authorized {
    return [accessToken key] != nil;
}

- (void)executeMethod: (NSString *)method withParams: (NSDictionary *)params delegate: (id<LInAPICallDelegate>)delegate {
    
    NSString *paramsString = [[NSString alloc] initWithDictionary:params];
    NSString *urlString    = [NSString stringWithFormat:@"%@%@?%@", kLinkedinAPIURL, method, paramsString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:consumer
                                       token:accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:delegate
                didFinishSelector:@selector(apiCallResult:didFinish:)
                  didFailSelector:@selector(apiCallResult:didFail:)];
}

- (void)executeMethod: (NSString *)method
           withParams: (NSDictionary *)params
        andHTTPMethod: (NSString *)httpMethod
             delegate: (id<LInAPICallDelegate>)delegate
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLinkedinAPIURL, method];
    
    NSURL *url = [NSURL URLWithString:urlString];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:consumer
                                       token:accessToken
                                    callback:nil
                           signatureProvider:nil];

    if ([httpMethod isEqual:@"POST"]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *updateString = [params JSONString];
        
        [request setHTTPBodyWithString:updateString];
        [request setHTTPMethod:@"POST"];
    } else {
        [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    }
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:delegate
                didFinishSelector:@selector(apiCallResult:didFinish:)
                  didFailSelector:@selector(apiCallResult:didFail:)];
}

#pragma mark - InLoginDialogDelegate

- (void)inDialogLogin {
    accessToken  = [_loginDialog accessToken];
    requestToken = [_loginDialog requestToken];
    consumer     = [_loginDialog consumer];
    
    if (_delegate) {
        [_delegate inDidLogin];
    }
}

- (void)inDialogNotLogin:(BOOL)cancelled {
    if (_delegate) {
        [_delegate inDidNotLogin];
    }
}

@end
