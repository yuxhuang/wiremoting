//
//  LoginViewController.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "LoginViewController.h"
#import "Moodle.h"

@implementation LoginViewController

@synthesize username;
@synthesize password;

- (void) execute
{
  [moodle login:self.username password:self.password];
  // add message to the view
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Logged In", @"title",
                    [NSString stringWithFormat:@"You are successfully logged in as %@.", username], @"description",
                    nil]];
}

@end

