//
//  TestProtocol.m
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-15.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "MockupProtocol.h"
#import "ASIFormDataRequest.h"


@implementation MockupProtocol

- (void) adjustRequest:(ASIFormDataRequest *)request
                method:(NSString *)method
             arguments:(NSDictionary *)arguments
{
  [request setURL:
   [NSURL URLWithString:@"http://p.webinit.org/wiremoting/mockup.php"]];
  [request setPostValue:method forKey:@"_method"];

  if (nil != arguments) {
    for (NSString *key in [arguments allKeys]) {
      [request setPostValue:[arguments valueForKey:key] forKey:key];
    }
  }
}

- (BOOL)isAsynchronous
{
  return NO;
}


@end
