//
//  LinkedIn.h
//  OAuthStarterKit
//
//  Created by Ilya Elovikov on 28/03/14.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"
#import "InLoginDialog.h"

@protocol LInSessionDelegate;
@protocol LInAPICallDelegate;

@interface LinkedInDataProvider : NSObject<InLoginDialogDelegate> {
    
@private
    OAToken *requestToken;
    OAToken *accessToken;
    OAConsumer *consumer;
    
    // Theses ivars could be made into a provider class
    // Then you could pass in different providers for Twitter, LinkedIn, etc
    NSString *apikey;
    NSString *secretkey;
    NSString *requestTokenURLString;
    NSURL    *requestTokenURL;
    NSString *accessTokenURLString;
    NSURL    *accessTokenURL;
    NSString *userLoginURLString;
    NSURL    *userLoginURL;
    NSString *linkedInCallbackURL;
}

+ (LinkedInDataProvider *)inststance;

@property (readonly) BOOL authorized;

- (void)authorizeWithDelegate: (id<LInSessionDelegate>)delegate;
- (void)executeMethod: (NSString *)method withParams: (NSDictionary *)params delegate: (id<LInAPICallDelegate>)delegate;
- (void)executeMethod: (NSString *)method
           withParams: (NSDictionary *)params
        andHTTPMethod: (NSString *)httpMethod
             delegate: (id<LInAPICallDelegate>)delegate;

@end


@protocol LInSessionDelegate <NSObject>

- (void)inDidLogin;
- (void)inDidNotLogin;

@end

@protocol LInAPICallDelegate <NSObject>

- (void)apiCallResult:(OAServiceTicket *)ticket didFinish:(id)data;
- (void)apiCallResult:(OAServiceTicket *)ticket didFail:(id)error;

@end
