//
//  MockProtocolShouldSend.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "MockProtocolShouldSend.h"
#import "ASIFormDataRequest.h"

@implementation MockProtocolShouldSend

- (BOOL) requestShouldSend: (ASIFormDataRequest*) request
                    method: (NSString*) method
                 arguments: (NSDictionary*) arguments
{
  return NO;
}

// adjust request runs before request should send
- (void) adjustRequest: (ASIFormDataRequest*) request
                method: (NSString*) method
             arguments: (NSDictionary*) arguments
{
  // nop
}

@end
