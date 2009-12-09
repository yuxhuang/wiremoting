//
//  MoodleExampleAppDelegate.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "MoodleExampleAppDelegate.h"
#import "RootViewController.h"


@implementation MoodleExampleAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize moodle;

static MoodleExampleAppDelegate *instance;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  
  instance = self;
  
  // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
  
  // Set status bar style
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  
  // initialize moodle
  moodle = [[Moodle alloc] init];
  
  [moodle login:@"student01" password:@"student01"];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

+ (MoodleExampleAppDelegate*) instance
{
  return instance;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  [moodle logout];
  [moodle release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end
