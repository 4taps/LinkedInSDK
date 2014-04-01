//
//  VKDialog.h
//  WC
//
//  Created by Ilya Elovikov on 26.04.12.
//  Copyright (c) 2012 i.elovikov@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

@protocol InLoginDialogDelegate;

@interface InLoginDialog : UIView <UIWebViewDelegate> {
    UIWebView *__webView;
    NSURL     *__loginURL;
    
    id<InLoginDialogDelegate> __delegate;
    
@protected
    OAToken    *requestToken;
    OAToken    *accessToken;
    OAConsumer *consumer;
    
    // Theses ivars could be made into a provider class
    // Then you could pass in different providers for Twitter, LinkedIn, etc
    
    NSURL    *requestTokenURL;
    NSURL    *accessTokenURL;
    NSURL    *userLoginURL;
}

@property NSString *apiKey;
@property NSString *secretKey;
@property NSString *requestTokenURLString;
@property NSString *accessTokenURLString;
@property NSString *userLoginURLString;
@property NSString *linkedInCallbackURL;

@property (nonatomic, retain) OAToken *requestToken;
@property (nonatomic, retain) OAToken *accessToken;
@property (nonatomic, retain) OAConsumer *consumer;

@property (nonatomic, retain) UILabel *splashLabel;
@property (nonatomic, retain) UIToolbar *toolbar;


-(id) initWithDelegate:(id <InLoginDialogDelegate>) theDelegate;

- (void) show;

@end

@protocol InLoginDialogDelegate <NSObject>

- (void)inDialogLogin;
- (void)inDialogNotLogin:(BOOL)cancelled;

@end
