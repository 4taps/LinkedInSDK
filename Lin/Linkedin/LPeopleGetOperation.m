//
//  LPeopleGetOperation.m
//  Lin
//
//  Created by Ilya Elovikov on 31/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import "LPeopleGetOperation.h"
#import "LLinkedIn.h"

@implementation LPeopleGetOperation

- (id)initWithDelegate:(id<LInMethodDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    
    _method = kPeopleGetMethod;
    
    return self;
}

- (void)apiCallResult:(OAServiceTicket *)ticket didFinish:(id)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *profile = [responseBody objectFromJSONString];
    
    [super apiCallResult:ticket didFinish:profile];
}

- (void)apiCallResult:(OAServiceTicket *)ticket didFail:(id)error
{
    NSLog(@"%@",[error description]);
}

@end
