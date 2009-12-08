//
//  GetCoursesViewController.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "GetCoursesViewController.h"
#import "Moodle.h"
#import "WIRemoting.h"
#import "ShowCourseViewController.h"

@implementation GetCoursesViewController

@synthesize mineOnly;

- (id) initWithTitle:(NSString *)title andDescription:(NSString *)aDescription
{
  self = [super initWithTitle:title andDescription:aDescription];
  
  if (nil != self) {
    mineOnly = NO;
  }
  
  return self;
}

- (void) execute
{
  if (mineOnly) {
    [moodle getMyCourses:self];
  }
  else {
    [moodle getCourses:self];
  }
}

- (void) finished:(RMResponse*) response
{
  NSDictionary *r = [[response responseString] JSONValue];
  // check error
  if ([[r valueForKey:@"error"] boolValue]) {
    // create a UIAlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[[r valueForKey:@"message"] valueForKey:@"string"]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
  
  // clear the views
  [views removeAllObjects];
  // get courses array
  NSArray *courses = [r valueForKey:@"courses"];
  for (NSDictionary *c in courses) {
    // check error
    if (![[c valueForKey:@"error"] isEqual:@""]) {
      // create a UIAlertView
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:[c valueForKey:@"error"]
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [alert show];
      [alert release];
      [self.navigationController popViewControllerAnimated:YES];
      break;
    }
    
    // add a new item
    ShowCourseViewController *controller =
        [[ShowCourseViewController alloc] initWithTitle:[c valueForKey:@"shortname"]
                                         andDescription:[c valueForKey:@"fullname"]];
    controller.courseId = [[c valueForKey:@"id"] intValue];
    [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                      [c valueForKey:@"shortname"], @"title",
                      [c valueForKey:@"fullname"], @"description",
                      controller, @"controller",
                      nil]];
    [controller release];
  }
  
  // refresh display
  [self.view reloadData];
  [self.view setNeedsDisplay];
  
}



@end

