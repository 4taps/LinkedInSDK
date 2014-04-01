//
//  NSStringUrlParams.m
//  WC
//
//  Created by Maxim on 6/20/12.
//  Copyright (c) 2012 i.elovikov@gmail.com. All rights reserved.
//

#import "NSStringUrlParams.h"

@implementation NSString (UrlParams)

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams {
    
    NSString *query = self;
    
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

- (NSString *) urlEncoding {
    NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                            NULL,
                                                                                            (__bridge CFStringRef)self,
                                                                                            NULL,
                                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                            kCFStringEncodingUTF8);
    
    return encodedString;
}

- (id) initWithDictionary: (NSDictionary *) params {
    NSMutableString * dest  = [NSMutableString string];
    NSString        * value = nil;
    
    for (NSString *param in [params keyEnumerator]) {
        value = [[[params valueForKey:param] description] stringByAddingPercentEscapesUsingEncoding:
                 NSUTF8StringEncoding];
        
        [dest appendFormat:@"%@=%@&", param, value];
    }
    
    self = dest;
    
    return self;
}

@end
