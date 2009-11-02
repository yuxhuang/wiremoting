//
//  RMSession.h
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMCall;
@protocol RMCallDelegate;
@class RMStatus;
@class RMArguments;

@protocol RMAuthenticator

- (void) authenticateWithCall: (RMCall*) call;
- (void) authenticated: (RMStatus*) status;
- (void) failed: (RMStatus*) status;

- (void) adjustCallArguments: (RMArguments*) arguments;

@end


@interface RMSession : NSObject {
  RMCall *call;
  id<RMAuthenticator> authenticator;
}

@property (retain) RMCall *call;

/**
 * Initiate a session with an authentication delegate
 *
 * Initiate a session asynchronously with an authentication delegate.
 *
 * @param authenticator
 * @param call
 */
- (id) initWithAuthentication: (id<RMAuthenticator>) authenticator
                callProtocol:(RMCall*) call;

- (BOOL) authenticate;
- (void) authenticateAsynchronous;
- (BOOL) isAuthenticated;

- (void)call:(NSString*) method
   arguments:(RMArguments*) arguments
    delegate:(id<RMCallDelegate>) delegate;

- (void)callAsynchronous:(NSString*) method
               arguments:(RMArguments*) arguments
                delegate:(id<RMCallDelegate>) delegate;

@end
