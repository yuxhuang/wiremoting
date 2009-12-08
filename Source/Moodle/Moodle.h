//
//  Moodle.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIRemoting.h"

@class MoodleAuthenticator;
@class MoodleCallProtocol;

@interface Moodle : NSObject {
  RMCall *call;
  RMSession *session;
  MoodleCallProtocol *protocol;
  MoodleAuthenticator *authenticator;
}

@property(readonly) BOOL loggedIn;

#pragma mark authentication

- (void) sync;

/**
 * Log in a Moodle system
 *
 * @param username the username to log in
 * @param password the password to log in
 */
-(void) login:(NSString*) username password:(NSString*) password;
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
-(void) getCourses:(id)delegate;
/**
 * Get a course with an ID
 *
 * @param courseId the course id
 * @return a course as an NSDictionary
 */
-(void) getCourse:(NSInteger) courseId delegate:(id)delegate;
/**
 * Get all my courses
 *
 * @return courses as an NSArray of NSDictionary
 */
-(void) getMyCourses:(id)delegate;
/**
 * Get all resources from a course
 *
 * @param courseId the course id
 * @return resources as an NSArray of NSDictionary
 */
-(void) getResources:(NSInteger) courseId delegate:(id)delegate;
/**
 * Get all teachers from a course
 *
 * @param courseId the course id
 * @return teachers as an NSArray of NSDictionary
 */
-(void) getTeachers:(NSInteger) courseId delegate:(id)delegate;

/**
 * Get all students from a course
 *
 * @param courseId the course id
 * @return resources as an NSArray of NSDictionary
 */
-(void) getStudents:(NSInteger) courseId delegate:(id)delegate;
/**
 * Get all activities of a course
 *
 * @param courseId the course id
 * @return activities as an NSArray of NSDictionary
 */
-(void) getActivities:(NSInteger) courseId delegate:(id)delegate;
/**
 * Get all activities of a course
 *
 * @param courseId the course id
 * @return activities as an NSArray of NSDictionary
 */
-(void) getLastChanges:(NSInteger) courseId delegate:(id)delegate;

@end
