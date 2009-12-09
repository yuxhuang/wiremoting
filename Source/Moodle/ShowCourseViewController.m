//
//  ShowCourseViewController.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "ShowCourseViewController.h"
#import "CourseDetailResultViewController.h"
#import "Moodle.h"

@implementation ShowCourseViewController

@synthesize courseId;

- (void) customize
{
  CourseDetailResultViewController *c;
  
  // teachers
  c = [[CourseDetailResultViewController alloc] initWithTitle:@"Teachers"
                                               andDescription:nil];
  c.courseId = self.courseId;
  c.selector = @selector(getTeachers:delegate:);
  c.arrayType = @"users";
  c.titleField = @"username";
  c.descriptionField = @"email";
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Teachers", @"title",
                    @"Retrieve teachers from this course", @"description",
                    c, @"controller",
                    nil]];
  [c release];
  
  // students
  c = [[CourseDetailResultViewController alloc] initWithTitle:@"Students"
                                               andDescription:nil];
  c.courseId = self.courseId;
  c.selector = @selector(getStudents:delegate:);
  c.arrayType = @"users";
  c.titleField = @"username";
  c.descriptionField = @"email";
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Students", @"title",
                    @"Retrieve students from this course", @"description",
                    c, @"controller",
                    nil]];
  [c release];

  // resources
  c = [[CourseDetailResultViewController alloc] initWithTitle:@"Resources"
                                               andDescription:nil];
  c.courseId = self.courseId;
  c.selector = @selector(getResources:delegate:);
  c.arrayType = @"resources";
  c.titleField = @"name";
  c.descriptionField = @"alltext";
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Resources", @"title",
                    @"Retrieve resources from this course", @"description",
                    c, @"controller",
                    nil]];
  [c release];

  // activities
  c = [[CourseDetailResultViewController alloc] initWithTitle:@"Activities"
                                               andDescription:nil];
  c.courseId = self.courseId;
  c.selector = @selector(getActivities:delegate:);
  c.arrayType = @"activities";
  c.titleField = @"email";
  c.descriptionField = @"DATE";
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Activities", @"title",
                    @"Retrieve activities from this course", @"description",
                    c, @"controller",
                    nil]];
  [c release];
  
  // changes
  c = [[CourseDetailResultViewController alloc] initWithTitle:@"Last Changes"
                                               andDescription:nil];
  c.courseId = self.courseId;
  c.selector = @selector(getLastChanges:delegate:);
  c.arrayType = @"changes";
  c.titleField = @"name";
  c.descriptionField = @"date";
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Last Changes", @"title",
                    @"Retrieve last changes from this course", @"description",
                    c, @"controller",
                    nil]];
  [c release];
}

@end

