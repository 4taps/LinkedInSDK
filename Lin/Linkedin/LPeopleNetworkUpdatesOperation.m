//
//  LPeopleNetworkUpdatesOperation.m
//  Lin
//
//  Created by Ilya Elovikov on 31/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import "LPeopleNetworkUpdatesOperation.h"
#import "LLinkedIn.h"

@implementation LPeopleNetworkUpdatesOperation

- (id)initWithParams: (NSDictionary *)params Delegate:(id<LInMethodDelegate>)delegate {
    self = [super initWithParams:params Delegate:delegate];
    
    _method = kPeopleNetworkUpdatesMethod;
    
    return self;
}

- (void)apiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *person = [[[[[responseBody objectFromJSONString]
                               objectForKey:@"values"]
                              objectAtIndex:0]
                             objectForKey:@"updateContent"]
                            objectForKey:@"person"];
    
    [super apiCallResult:ticket didFinish:person];
}

- (void)apiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

@end
