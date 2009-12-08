//
//  LogoutViewController.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "LogoutViewController.h"
#import "Moodle.h"

@implementation LogoutViewController

- (void) execute
{
  [moodle logout];
  // add message to the view
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Logged Out", @"title",
                    @"You are successfully logged out.", @"description",
                    nil]];
}
@end

