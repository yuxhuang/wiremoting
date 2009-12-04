//
//  Mock.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-02.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "Mock.h"


@implementation Mock

- (id)initWithObject:(id) obj finished:(SEL) fin failed:(SEL) fai
{
  self = [super init];
  
  if (nil != self) {
    object = obj;
    finished = fin;
    failed = fai;
  }
  
  return self;
}

- (void) finished:(RMResponse *) response
{
  [object performSelector:finished 
               withObject:response];
}

- (void) failed:(RMResponse *) response
              error:(NSError *) error
{
  [object performSelector:failed
               withObject:response
               withObject:error];
}

@end
