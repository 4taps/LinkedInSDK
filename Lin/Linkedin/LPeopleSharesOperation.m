//
//  LPeopleSharesOperation.m
//  Lin
//
//  Created by Ilya Elovikov on 31/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import "LPeopleSharesOperation.h"
#import "LLinkedIn.h"

@implementation LPeopleSharesOperation

- (id)initWithParams: (NSDictionary *)params Delegate:(id<LInMethodDelegate>)delegate {
    self = [super initWithParams:params Delegate:delegate];
    
    _method = kPeopleSharesMethod;
    
    return self;
}

- (void)methodExecute {
    [_linkedIn executeMethod:_method withParams:_params andHTTPMethod:@"POST" delegate:self];
}

@end
