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


@end
