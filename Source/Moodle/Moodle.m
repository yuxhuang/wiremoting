//
//  Moodle.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "Moodle.h"
#import "MoodleAuthenticator.h"
#import "MoodleCallProtocol.h"

@implementation Moodle

@dynamic loggedIn;

- (id) init
{
  self = [super init];
  
  if (nil != self) {
    protocol = [[MoodleCallProtocol alloc] init];
    call = [[RMCall alloc] initWithProtocol:protocol];
  }
  
  return self;
}

- (void) dealloc
{
  [authenticator release];
  [session release];
  [call release];
  [protocol release];
  [super dealloc];
}

- (void) sync
{
  protocol.async = NO;
}

-(void) login:(NSString*) username password:(NSString*) password
{
  authenticator = [[MoodleAuthenticator alloc]
                   initWithUsername:username password:password];
  session = [[RMSession alloc] initWithAuthenticator:authenticator
                                                call:call];
  [session authenticate];
}

- (BOOL) loggedIn
{
  return session.authenticated;
}

-(void) logout
{
  [authenticator release];
  authenticator = nil;
  [session release];
  session = nil;
}

-(void) getCourses:(id)delegate
{
  @synchronized(call.semaphore) {
    [call addDelegate:delegate];
    [call call:@"get_courses" arguments:nil];
    [call removeDelegate:delegate];
  }
}

@end
