//
//  LInBaseOperation.m
//  Lin
//
//  Created by Ilya Elovikov on 31/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import "LInBaseOperation.h"
#import "LLinkedIn.h"

@implementation LInBaseOperation

- (id)initWithDelegate: (id<LInMethodDelegate>)delegate {
    self = [super init];
    
    _linkedIn = [LinkedInDataProvider inststance];
    _delegate = delegate;
    
    return self;
}

- (id)initWithParams: (NSDictionary *)params Delegate:(id<LInMethodDelegate>)delegate {
    self = [self initWithDelegate:delegate];
    
    _params = [NSMutableDictionary dictionaryWithDictionary: params];
    
    return self;
}

- (id)initWithParams: (NSDictionary *)params andFields: (NSArray *)fields Delegate:(id<LInMethodDelegate>)delegate {
    self = [self initWithParams:params Delegate:delegate];
    
    _fields = fields;
    
    if (fields) {
        NSString *fieldsString = [NSString stringWithFormat: @":(%@)", [fields componentsJoinedByString:@","]];
        _method = [NSString stringWithFormat:@"%@%@", _method, fieldsString];
    }
    
    return self;
}

- (void)clean {
    
    _delegate = nil;
    _linkedIn = nil;
    _params   = nil;
    _fields   = nil;
}

- (void)methodExecute {
    [_linkedIn executeMethod: _method withParams:_params delegate:self];
}

- (void)main {
    if (![_linkedIn authorized]) {
        [_linkedIn authorizeWithDelegate:self];
    } else {
        [self methodExecute];
    }
}

#pragma mark - InSessionDelegate

- (void)inDidLogin {
    [self methodExecute];
}

- (void)inDidNotLogin {
    if (_delegate) {
        [_delegate inMethodDidFinished:_method withError:[NSError errorWithDomain:@"Linkedin not login" code:501 userInfo:nil]];
    }
    
    [self clean];
}

#pragma mark - LInAPICallDelegate

- (void)apiCallResult:(OAServiceTicket *)ticket didFinish:(id)data {
    if (_delegate) {
        [_delegate inMethodDidFinished:_method withResult:data];
    }
    
    [self clean];
}
- (void)apiCallResult:(OAServiceTicket *)ticket didFail:(id)error {
    if (_delegate) {
        [_delegate inMethodDidFinished:_method withError:[NSError errorWithDomain:@"Linkedin method error" code:400 userInfo:nil]];
    }
    
    [self clean];
}

@end
