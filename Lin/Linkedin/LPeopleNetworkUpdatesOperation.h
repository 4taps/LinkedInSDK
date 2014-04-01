//
//  LPeopleNetworkUpdatesOperation.h
//  Lin
//
//  Created by Ilya Elovikov on 31/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LInBaseOperation.h"

#define kLinScopeParam @"scope"
#define kLinCountParam @"count"
#define kLinTypeParam  @"type"

//?scope=self&count=1&type=STAT
@interface LPeopleNetworkUpdatesOperation : LInBaseOperation

- (id)initWithParams: (NSDictionary *)params Delegate:(id<LInMethodDelegate>)delegate;

@end
