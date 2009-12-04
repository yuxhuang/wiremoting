//
//  Moodle.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIRemoting.h"

@interface Moodle : NSObject {
  RMSession *session;
}

#pragma mark authentication
/**
 * Log in a Moodle system
 *
 * @param username the username to log in
 * @param password the password to log in
 */
-(void) login:(NSString*) username password:(NSString*) password;
/**
 * Login Success Handler
 */
-(void) loginSuccess:(RMResponse*) response;
/**
 * Failure handler
 */
-(void) failed:(RMResponse*) response error:(NSError*) error;
/**
 * Log out from a Moodle system
 */
-(void) logout;

#pragma mark courses

/**
 * Get all courses
 *
 * @return courses as an NSArray of NSDictionary
 */
-(NSArray*) getCourses;
/**
 * Get a course with an ID
 *
 * @param courseId the course id
 * @return a course as an NSDictionary
 */
-(NSDictionary*) getCourse:(NSInteger) courseId;
/**
 * Get all my courses
 *
 * @return courses as an NSArray of NSDictionary
 */
-(NSArray*) getMyCourses;
/**
 * Get all resources from a course
 *
 * @param courseId the course id
 * @return resources as an NSArray of NSDictionary
 */
-(NSArray*) getResources:(NSInteger) courseId;
/**
 * Get all teachers from a course
 *
 * @param courseId the course id
 * @return teachers as an NSArray of NSDictionary
 */
-(NSArray*) getTeachers:(NSInteger) courseId;

/**
 * Get all students from a course
 *
 * @param courseId the course id
 * @return resources as an NSArray of NSDictionary
 */
-(NSArray*) getStudents:(NSInteger) courseId;
/**
 * Get all activities of a course
 *
 * @param courseId the course id
 * @return activities as an NSArray of NSDictionary
 */
-(NSArray*) getActivities:(NSInteger) courseId;

@end
