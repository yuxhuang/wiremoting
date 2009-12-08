//
//  MoodleAuthenticator.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIRemoting.h"

@interface MoodleAuthenticator : NSObject<RMAuthenticator,RMCallProtocol> {
  NSString *username;
  NSString *password;
  RMResultDelegateWrapper *wrapper;
}


- (id)initWithUsername:(NSString*)username
              password:(NSString *)password;

@end
