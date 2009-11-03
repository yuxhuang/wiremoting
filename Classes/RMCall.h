//
//  RMCall.h
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMArguments;
@class RMResponse;
@class RMError;
@class ASIHTTPRequest;

@protocol RMCallProtocol

@optional
- (BOOL) shouldSendRequest: (ASIHTTPRequest*) request
                    method: (NSString*) method
                 arguments: (RMArguments*) arguments;

@optional
- (void) willSendRequest: (ASIHTTPRequest*) request
                  method: (NSString*) method
               arguments: (RMArguments*) arguments;

@optional
- (void) sentRequest: (ASIHTTPRequest*) request
                  method: (NSString*) method
               arguments: (RMArguments*) arguments;

@optional
- (BOOL) shouldAdjustRequest: (ASIHTTPRequest*) request
                           method: (NSString*) method
                        arguments: (RMArguments*) arguments;

@optional
- (void) willAdjustRequest: (ASIHTTPRequest*) request
                    method: (NSString*) method
                 arguments: (RMArguments*) arguments;

@required
- (void) adjustRequest: (ASIHTTPRequest*) request
                method: (NSString*) method
             arguments: (RMArguments*) arguments;
@end

@protocol RMCallDelegate

@required
- (void) callFinished: (RMResponse*) response;

@required
- (void) callFailed: (RMResponse*) response
              error: (RMError*) error;

@end

@interface RMCall : NSObject {
  id<RMCallProtocol> protocol;
}

@property(retain) id<RMCallProtocol> protocol;

- (id)initWithProtocol: (id<RMCallProtocol>) protocol;

- (void)call:(NSString*) method
   arguments:(RMArguments*) arguments
    delegate:(id<RMCallDelegate>) delegate;

- (void)call:(NSString*) method
   arguments:(RMArguments*) arguments
    delegate:(id<RMCallDelegate>) delegate
    protocol:(id<RMCallProtocol>) protocol;

- (void)callAsynchronous:(NSString*) method
               arguments:(RMArguments*) arguments
                delegate:(id<RMCallDelegate>) delegate;

- (void)callAsynchronous:(NSString*) method
               arguments:(RMArguments*) arguments
                delegate:(id<RMCallDelegate>) delegate
                protocol:(id<RMCallProtocol>) protocol;

@end
