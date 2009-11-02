//
//  RMArguments.h
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RMArguments : NSObject {

}

- (void)setValue:(NSObject*) value
    forKey:(NSString*) key;

- (NSObject*)valueForKey: (NSString*) key;

- (NSDictionary*)arguments;

@end
