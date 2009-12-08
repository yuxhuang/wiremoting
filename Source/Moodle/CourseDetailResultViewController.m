//
//  CourseDetailResultViewController.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "CourseDetailResultViewController.h"
#import "WIRemoting.h"
#import "Moodle.h"

@implementation CourseDetailResultViewController

@synthesize courseId;
@synthesize selector;
@synthesize arrayType;
@synthesize titleField;
@synthesize descriptionField;

- (void) execute
{
  if ([moodle respondsToSelector:selector]) {
    [moodle performSelector:selector
                 withObject:courseId
                 withObject:self];
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
  
  // clear the view
  [views removeAllObjects];
  // get courses array
  NSArray *objects = [r valueForKey:arrayType];
  
  for (NSDictionary *obj in objects) {
    // check error
    if (![[obj valueForKey:@"error"] isEqual:@""]) {
      // create a UIAlertView
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:[obj valueForKey:@"error"]
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [alert show];
      [alert release];
      break;
    }
    
    // add a new item
    [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                      [obj valueForKey:titleField], @"title",
                      [obj valueForKey:descriptionField], @"description",
                      nil]];
  }
  
  // refresh display
  [self.view reloadData];
  [self.view setNeedsDisplay];
  
}


@end

