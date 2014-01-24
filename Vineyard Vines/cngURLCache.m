//
//  cngURLCache.m
//  Vineyard Vines
//
//  Created by Michael Flynn on 1/24/14.
//  Copyright (c) 2014 CN Gann Technology Group. All rights reserved.
//

#import "cngURLCache.h"

@implementation cngURLCache

- (NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest*)request
{
    NSLog(@" Blocked Caching Successfully. ");
    // Development
    return nil;
    // Launch
    //[super cachedResponseForRequest:request];
}

@end
