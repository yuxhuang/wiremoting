//
//  RMCall.h
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMStatus;
@class RMArguments;
@class RMResponse;

@protocol RMCallDelegate

- (void) invoke: (NSString*) method
      arguments: (RMArguments*) arguments;

- (void) invokeAsynchronous: (NSString*) method
                  arguments: (RMArguments*) arguments;

- (void) callFinished: (RMResponse*) response;

- (void) callFailed: (RMStatus*) status;

@end


@interface RMCall : NSObject {
  id<RMCallDelegate> delegate;
}

@property(readonly) id<RMCallDelegate> delegate;

- (id)initWithDelegate: (id<RMCallDelegate>) delegate;

- (void)call:(NSString*) method
   arguments:(RMArguments*) arguments
    delegate:(id<RMCallDelegate>) delegate;

- (void)callAsynchronous:(NSString*) method
               arguments:(RMArguments*) arguments
                delegate:(id<RMCallDelegate>) delegate;
@end
