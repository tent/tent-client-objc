//
//  NSString+URLEncode.m
//  TentClient
//
//  Created by Jesse Stuart on 10/3/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)

- (NSString *)stringByAddingURLPercentEncoding {
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    kCFAllocatorDefault,                     // allocator
                                                                    (CFStringRef)self,                       // originalString
                                                                    NULL,                                    // charactersToLeaveUnescaped
                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", // legalURLCharactersToBeEscaped
                                                                    kCFStringEncodingUTF8 );                 // encoding

    return (NSString *)CFBridgingRelease(urlString);
}

@end
