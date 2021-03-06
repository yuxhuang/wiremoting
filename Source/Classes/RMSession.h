//
//  RMSession.h
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMCall;
@protocol RMResultDelegate;
@protocol RMCallProtocol;
@class RMResponse;
@class ASIHTTPRequest;


/**
 * The authentication provider.
 */
@protocol RMAuthenticator <NSObject>

@required
/**
 * Authenticate the session with a call object.
 *
 * @param call a RMCall object.
 * @param delegate a RMSessionDelegate.
 */
- (void) authenticateWithCall: (RMCall*) call;
@required
/**
 * A call protocol to handle session credentials for subsequent calls.
 *
 * @return An object implementing RMCallProtocol.
 */
- (id<RMCallProtocol>) callProtocol;

@optional
/**
 * Check the responseString if the response is authenticated
 *
 * @param responseString
 * @return true if the session is authenticated
 */
- (BOOL) authenticateResponseString:(NSString*) responseString;

@optional
/**
 * Check the responseData if the response is authenticated
 *
 * @param responseData
 * @return true if the session is authenticated
 */
- (BOOL) authenticateResponseData:(NSData*) responseData;

@end

/**
 * Handles sessions in WIRemoting framework.
 */
@interface RMSession : NSObject<RMResultDelegate> {
  RMCall *call;
  id<RMAuthenticator> authenticator;
  NSMutableArray *delegateChain;
  BOOL authenticated;
}

/**
 * The call object to handle session calls.
 */
@property (readonly) RMCall *call;
/**
 * Semaphore for locking
 */
@property (readonly,getter=semaphore) id semaphore;

/**
 * Initiate a session with an authentication delegate.
 *
 * @param authenticator An authentication service provider.
 * @param call A call object to handle session calls.
 *
 * @return An initiated RMSession object.
 */
- (id) initWithAuthenticator: (id<RMAuthenticator>) authenticator
                        call:(RMCall*) call;

/**
 * Authenticate the session.
 */
- (void) authenticate;

/**
 * Return the state whether the session is authenticated.
 *
 * @return whether the session is authenticated.
 */
@property(readonly) BOOL authenticated;

/**
 * Call a method.
 *
 * @param method The method name.
 * @param arguments Method arguments.
 */
- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments;

/**
 * Call a remote method with a temporary delegate
 *
 * @param method The method name.
 * @param arguments The method arguments.
 * @param delegate a delegate
 *
 * @return whether the call is sent.
 */
- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
    delegate:(id) delegate;


/**
 * Close a session.
 */
- (void)close;

/**
 * Add a new delegate
 *
 * @param delegate A delegate
 */
- (void) addDelegate: (id<RMResultDelegate>) delegate;

/**
 * Remove a delegate
 *
 * @param delegate A delegate
 */
- (void) removeDelegate: (id<RMResultDelegate>) delegate;

@end
