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
  if (nil != authenticator && nil != session) {
    [self logout];
  }
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
  [session call:@"logout" arguments:nil];
  [authenticator release];
  authenticator = nil;
  [session release];
  session = nil;
}

-(void) getCourses:(id)delegate
{
  [session call:@"get_courses" arguments:nil delegate:delegate];
}

-(void) getCourse:(NSInteger) courseId delegate:(id)delegate
{
  [session call:@"get_courses"
      arguments:[NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithInt:courseId], @"value",
                 @"id", @"idfield", nil]
       delegate:delegate];
}

-(void) getMyCourses:(id)delegate
{
  [session call:@"get_my_courses" arguments:nil delegate:delegate];
}

-(void) getResources:(NSInteger) courseId delegate:(id)delegate
{
  [session call:@"get_resources"
      arguments:[NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObject:[NSNumber numberWithInt:courseId]], @"value",
                 @"id", @"idfield", nil]
       delegate:delegate];
}

-(void) getTeachers:(NSInteger) courseId delegate:(id)delegate
{
  [session call:@"get_teachers"
      arguments:[NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithInt:courseId], @"value",
                 @"id", @"idfield", nil]
       delegate:delegate];
}

-(void) getStudents:(NSInteger) courseId delegate:(id)delegate
{
  [session call:@"get_students"
      arguments:[NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithInt:courseId], @"value",
                 @"id", @"idfield", nil]
       delegate:delegate];
}

-(void) getActivities:(NSInteger) courseId delegate:(id)delegate
{
  [session call:@"get_activities"
      arguments:[NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithInt:courseId], @"value",
                 @"id", @"idfield", nil]
       delegate:delegate];
}

-(void) getLastChanges:(NSInteger) courseId delegate:(id)delegate
{
  [session call:@"get_last_changes"
      arguments:[NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithInt:courseId], @"value",
                 @"id", @"idfield", nil]
       delegate:delegate];
}


@end
