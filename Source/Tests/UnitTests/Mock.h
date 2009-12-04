//
//  Mock.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-02.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMResponse;
@protocol RMResultDelegate;

@interface Mock : NSObject<RMResultDelegate> {
  id object;
  SEL finished;
  SEL failed;
}

- (id)initWithObject:(id) obj finished:(SEL) fin failed:(SEL) fai;

- (void) finished:(RMResponse *) response;

- (void) failed:(RMResponse *) response
              error:(NSError *) error;

@end
