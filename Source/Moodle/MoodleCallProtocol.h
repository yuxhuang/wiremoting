//
//  MoodleCallProtocol.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIRemoting.h"

@interface MoodleCallProtocol : NSObject<RMCallProtocol> {
  BOOL async;
}

@property(assign) BOOL async;

@end
