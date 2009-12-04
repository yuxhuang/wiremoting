//
//  MockProtocol2.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-02.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "MockProtocol2.h"
#import "ASIFormDataRequest.h"

@implementation MockProtocol2

- (void) adjustRequest:(ASIFormDataRequest *)request method:(NSString *)method arguments:(NSDictionary *)arguments
{
  [request setPostValue:@"json_echo" forKey:@"_method"];
}

@end
