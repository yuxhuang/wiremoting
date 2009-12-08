//
//  MoodleExampleAppDelegate.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIRemoting.h"
#import "Moodle.h"

@interface MoodleExampleAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UINavigationController *navigationController;
  Moodle *moodle;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (readonly) IBOutlet Moodle *moodle;

+(MoodleExampleAppDelegate*) instance;

@end