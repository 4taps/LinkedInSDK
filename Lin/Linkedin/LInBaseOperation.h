//
//  LInBaseOperation.h
//  Lin
//
//  Created by Ilya Elovikov on 31/03/14.
//  Copyright (c) 2014 4taps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinkedInDataProvider.h"

@protocol LInMethodDelegate;

@interface LInBaseOperation : NSOperation<LInSessionDelegate, LInAPICallDelegate> {

@protected
    LinkedInDataProvider *_linkedIn;
    NSString             *_method;
    NSString             *_httpMethod;
    NSMutableDictionary  *_params;
    NSArray              *_fields;
}

@property (readonly) id<LInMethodDelegate> delegate;

- (id)initWithDelegate: (id<LInMethodDelegate>)delegate;
- (id)initWithParams: (NSDictionary *)params Delegate:(id<LInMethodDelegate>)delegate;
- (id)initWithParams: (NSDictionary *)params andFields: (NSArray *)fields Delegate:(id<LInMethodDelegate>)delegate;
- (void)methodExecute;

@end

@protocol LInMethodDelegate <NSObject>

- (void)inMethodDidFinished: (NSString *)method withResult: (id)result;
- (void)inMethodDidFinished: (NSString *)method withError: (NSError *)error;

@end
