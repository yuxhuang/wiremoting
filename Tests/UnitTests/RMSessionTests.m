//
//  RMSessionTests.m
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-14.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "RMSessionTests.h"


@implementation RMSessionTests

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void) testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}


#endif


@end
