//
//  MoodleResult.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "MoodleResult.h"
#import "WIRemoting.h"

@implementation MoodleResult

@synthesize result;

- (void)dealloc
{
  [result release];
  [super dealloc];
}

- (void) finished:(RMResponse *)response
{
  result = [[[response responseString] JSONValue] copy];
}

- (void) failed:(RMResponse *)response error:(NSError *)error
{
  NSException *e = [NSException exceptionWithName:@"MoodleResultException"
                                           reason:[error localizedFailureReason]
                                         userInfo:nil];
  @throw e;
}

@end
