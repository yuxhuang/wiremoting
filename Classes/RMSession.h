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
@protocol RMCallProtocol;
@class RMResponse;
@class RMError;
@class ASIHTTPRequest;


/**
 * The session delegate to handle authentication events.
 */
@protocol RMSessionDelegate

@required
/**
 * Called when the session is authenticated.
 *
 * @param response A response object of the call containing arbitrary forms
 *        of results.
 */
- (void) authenticated: (RMResponse*) response;

@required
/**
 * Called when the session has failed.
 *
 * @param response A response object of the call containing arbitrary forms
 *        of results.
 * @param error An error object from the call describing what the error is.
 */
- (void) failed: (RMResponse*) response
          error: (RMError*) error;

@end

/**
 * The authentication provider.
 */
@protocol RMAuthenticator

@required
/**
 * Authenticate the session with a call object.
 *
 * @param call a RMCall object.
 * @param delegate a RMSessionDelegate.
 */
- (void) authenticateWithCall: (RMCall*) call
                     delegate: (id<RMSessionDelegate>) delegate;
@required
/**
 * A call protocol to handle session credentials for subsequent calls.
 *
 * @return An object implementing RMCallProtocol.
 */
- (id<RMCallProtocol>) callProtocol;

@end

/**
 * Handles sessions in WIRemoting framework.
 */
@interface RMSession : NSObject {
  RMCall *call;
  id<RMAuthenticator> authenticator;
  id<RMSessionDelegate> delegate;
}

/**
 * The call object to handle session calls.
 */
@property (retain) RMCall *call;
/**
 * The session delegate to handle authentication events.
 */
@property (retain) id<RMSessionDelegate> delegate;

/**
 * Initiate a session with an authentication delegate.
 *
 * @param authenticator An authentication service provider.
 * @param call A call object to handle session calls.
 * @param delegate A session delegate to handle authentication events.
 *
 * @return An initiated RMSession object.
 */
- (id) initWithAuthenticator: (id<RMAuthenticator>) authenticator
                        call:(RMCall*) call
                    delegate: (id<RMSessionDelegate>) delegate;

/**
 * Authenticate the session.
 */
- (void) authenticate;

/**
 * Return the state whether the session is authenticated.
 *
 * @return whether the session is authenticated.
 */
- (BOOL) isAuthenticated;

/**
 * Call a method.
 *
 * @param method The method name.
 * @param arguments Method arguments.
 * @param delegate The call delegate to handle call results.
 */
- (void)call:(NSString*) method
   arguments:(NSDictionary*) arguments
    delegate:(id<RMCallDelegate>) delegate;

/**
 * Close a session.
 */
- (void)close;
@end
