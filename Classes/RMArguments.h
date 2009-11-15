//
//  RMArguments.h
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RMArguments : NSObject {
  NSMutableDictionary *dictionary;
}

/**
 * Set a new argument
 *
 * @param value The argument value.
 * @param key The argument key.
 */
- (void)setValue:(NSObject*) value
    forKey:(NSString*) key;

/**
 * Get the argument value for a key.
 *
 * @param key The argument key.
 */
- (NSObject*)valueForKey: (NSString*) key;

/**
 * Get arguments as a NSDictionary.
 *
 * @return An NSDictionary instance of arguments.
 */
- (NSDictionary*)arguments;

@end
