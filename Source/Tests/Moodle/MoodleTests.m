//
//  MoodleTests
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "MoodleTests.h"
#import "Moodle.h"

@implementation MoodleTests

- (void) setUp
{
  moodle = [[Moodle alloc] init];
  [moodle sync];
}

- (void) tearDown
{
  [moodle release];
}

- (void) testLogin
{
  [moodle login:@"admin" password:@"1234"];
  if (!moodle.loggedIn) {
    STFail(@"Unable to log in");
  }
}

- (void) testWrongLogin
{
  [moodle login:@"admin" password:@"123"];
  if (moodle.loggedIn) {
    STFail(@"Cannot detect incorrect username and password.");
  }
}

- (void) testLogout
{
  [self testLogin];
  [moodle logout];
  if (moodle.loggedIn) {
    STFail(@"Cannot log out");
  }
}

- (void) testGetCourses
{
  [self testLogin];
  RMResultDelegateWrapper *w = [[RMResultDelegateWrapper alloc]
                                initWithObject:self
                                finished:@selector(getCoursesFinished:)
                                failed:@selector(failed:error:)];
  [moodle getCourses:w];
}

- (void)getCoursesFinished:(RMResponse*) response
{
  id r = [[response responseString] JSONValue];
  if (![r isKindOfClass:[NSDictionary class]]) {
    STFail(@"Not a dictionary");
  }
  r = [r valueForKey:@"courses"];
  if (nil == r || ![r isKindOfClass:[NSArray class]]) {
    STFail(@"Courses not recognized.");
  }
}

- (void) testGetSingleCourse
{
  [self testLogin];
  RMResultDelegateWrapper *w = [[RMResultDelegateWrapper alloc]
                                initWithObject:self
                                finished:@selector(getCoursesFinished:)
                                failed:@selector(failed:error:)];
  [moodle getCourse:1 delegate:w];
}

- (void) testGetMyCourses
{
  [self testLogin];
  RMResultDelegateWrapper *w = [[RMResultDelegateWrapper alloc]
                                initWithObject:self
                                finished:@selector(getCoursesFinished:)
                                failed:@selector(failed:error:)];
  [moodle getMyCourses:w];
}

- (void) testGetResources
{
  [self testLogin];
  RMResultDelegateWrapper *w = [[RMResultDelegateWrapper alloc]
                                initWithObject:self
                                finished:@selector(getResourcesFinished:)
                                failed:@selector(failed:error:)];
  [moodle getResources:1 delegate:w];
}

- (void)getResourcesFinished:(RMResponse*) response
{
  id r = [[response responseString] JSONValue];
  if (![r isKindOfClass:[NSDictionary class]]) {
    STFail(@"Not a dictionary");
  }
  r = [r valueForKey:@"resources"];
  if (nil == r || ![r isKindOfClass:[NSArray class]]) {
    STFail(@"Resources not recognized.");
  }
}

- (void) testGetTeachers
{
  [self testLogin];
  RMResultDelegateWrapper *w = [[RMResultDelegateWrapper alloc]
                                initWithObject:self
                                finished:@selector(getUsersFinished:)
                                failed:@selector(failed:error:)];
  [moodle getTeachers:1 delegate:w];
}

- (void)getUsersFinished:(RMResponse*) response
{
  id r = [[response responseString] JSONValue];
  if (![r isKindOfClass:[NSDictionary class]]) {
    STFail(@"Not a dictionary");
  }
  r = [r valueForKey:@"users"];
  if (nil == r || ![r isKindOfClass:[NSArray class]]) {
    STFail(@"Users not recognized.");
  }
}

- (void) testGetStudents
{
  [self testLogin];
  RMResultDelegateWrapper *w = [[RMResultDelegateWrapper alloc]
                                initWithObject:self
                                finished:@selector(getUsersFinished:)
                                failed:@selector(failed:error:)];
  [moodle getStudents:1 delegate:w];
}

- (void) testGetActivities
{
  [self testLogin];
  RMResultDelegateWrapper *w = [[RMResultDelegateWrapper alloc]
                                initWithObject:self
                                finished:@selector(getActivitiesFinished:)
                                failed:@selector(failed:error:)];
  [moodle getActivities:1 delegate:w];
}

- (void)getActivitiesFinished:(RMResponse*) response
{
  id r = [[response responseString] JSONValue];
  if (![r isKindOfClass:[NSDictionary class]]) {
    STFail(@"Not a dictionary");
  }
  r = [r valueForKey:@"activities"];
  if (nil == r || ![r isKindOfClass:[NSArray class]]) {
    STFail(@"Activities not recognized.");
  }
}

- (void) testGetLastChanges
{
  [self testLogin];
  RMResultDelegateWrapper *w = [[RMResultDelegateWrapper alloc]
                                initWithObject:self
                                finished:@selector(getChangesFinished:)
                                failed:@selector(failed:error:)];
  [moodle getLastChanges:1 delegate:w];
}

- (void)getChangesFinished:(RMResponse*) response
{
  id r = [[response responseString] JSONValue];
  if (![r isKindOfClass:[NSDictionary class]]) {
    STFail(@"Not a dictionary");
  }
  r = [r valueForKey:@"changes"];
  if (nil == r || ![r isKindOfClass:[NSArray class]]) {
    STFail(@"Changes not recognized.");
  }
}


#pragma mark support functions
- (void)failed:(RMResponse*) response error:(NSError*) error
{
  STFail([error localizedFailureReason]);
}

@end
