//
//  NSStringUrlParams.h
//  WC
//
//  Created by Maxim on 6/20/12.
//  Copyright (c) 2012 i.elovikov@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlParams)

- (NSDictionary*)parseURLParams;
- (NSString *) urlEncoding;

- (id) initWithDictionary: (NSDictionary *) params;

@end
