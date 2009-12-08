//
//  MoodleCallProtocol.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "MoodleCallProtocol.h"
#import "WIRemoting.h"

@implementation MoodleCallProtocol

@synthesize async;

- (id) init
{
  self = [super init];
  
  if (nil != self) {
    async = YES;
  }
  
  return self;
}

- (void) adjustRequest:(ASIFormDataRequest *)request
                method:(NSString *)method
             arguments:(NSDictionary *)arguments
{
  // set the request's endpoint address
  [request setURL:
   [NSURL URLWithString:@"http://www.webinit.org/srv/soaprest.php"]];
  // enter the method
  [request setPostValue:method forKey:@"_method"];
  // enter the arguments
  for (NSString *key in [arguments allKeys]) {
    [request setPostValue:[arguments valueForKey:key] forKey:key];
  }
}

- (BOOL) isAsynchronous
{
  return async;
}

@end
