//
//  TentClient.m
//  TentClient
//
//  Created by Jesse Stuart on 8/10/13.
//  Copyright (c) 2013 Tent. All rights reserved.
//

#import "TentClient.h"
#import "AFHTTPRequestOperation.h"
#import "HTTPLinkHeader.h"

@implementation TentClient

+ (instancetype)clientWithEntity:(NSURL *)entityURI {
    TentClient *client = [[TentClient alloc] init];

    client.entityURI = entityURI;

    return client;
}

- (void)performDiscovery {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.entityURI];
    [request setHTTPMethod: @"HEAD"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    // Disable default behaviour to use basic auth
    operation.shouldUseCredentialStorage = NO;

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id __unused responseObject) {
        NSString *linkHeader = [[operation.response allHeaderFields] valueForKey:@"Link"];

        HTTPLinkHeader *metaPostLink = [self parseLinkHeader:linkHeader fromURL:[operation.response valueForKey:@"URL"]];

        if (!metaPostLink) {
            // HEAD discover failed
            // TODO: fallback to GET discovery
            NSLog(@"link header not found!");

            return;
        }

        self.metaPostURL = metaPostLink.URL;

        NSLog(@"meta post URL found: %@", [self.metaPostURL absoluteString]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to perform discovery on %@: %@", self.entityURI, error);
    }];

    [operation start];
}

- (HTTPLinkHeader *)parseLinkHeader:(NSString *)linkHeader fromURL:(NSURL *)originURL {
    // set metaPostURL property

    NSArray *links = [HTTPLinkHeader parseLinks:linkHeader];

    NSUInteger index = [links indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        HTTPLinkHeader * link = obj;
        return [[link.attribtues valueForKey:@"rel"] isEqualToString:@"https://tent.io/rels/meta-post"];
    }];

    if (index == NSNotFound) {
        return NULL;
    }

    HTTPLinkHeader *metaPostLink = [links objectAtIndex:index];

    if (!metaPostLink.URL.scheme) {
        metaPostLink.URL = [NSURL URLWithString:[metaPostLink.URL absoluteString] relativeToURL:originURL];
    }

    return metaPostLink;
}

@end
