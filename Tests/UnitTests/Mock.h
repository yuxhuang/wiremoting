//
//  Mock.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-02.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMResponse;
@protocol RMCallDelegate;

@interface Mock : NSObject<RMCallDelegate> {
  id object;
  SEL finished;
  SEL failed;
}

- (id)initWithObject:(id) obj finished:(SEL) fin failed:(SEL) fai;

- (void) callFinished:(RMResponse *) response;

- (void) callFailed:(RMResponse *) response
              error:(NSError *) error;

@end
