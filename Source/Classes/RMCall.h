//
//  RMCall.h
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMResponse;
@class ASIFormDataRequest;

/**
 * Provides call protocol interface/implementation.
 */
@protocol RMCallProtocol <NSObject>

@optional
/**
 * Should the request be sent?
 *
 * @param request The request object.
 * @param method The method name.
 * @param arguments The arguments for the call.
 *
 * @return Whether this request should be sent.
 */
- (BOOL) requestShouldSend: (ASIFormDataRequest*) request
                    method: (NSString*) method
                 arguments: (NSDictionary*) arguments;

@optional
/**
 * An event fired just before the request is sent.
 *
 * @param request The request object.
 * @param method The method name.
 * @param arguments The arguments for the call.
 */
- (void) requestWillSend: (ASIFormDataRequest*) request
                  method: (NSString*) method
               arguments: (NSDictionary*) arguments;

@optional
/**
 * An event fired just after the request is sent.
 *
 * @param request The request object.
 * @param method The method name.
 * @param arguments The arguments for the call.
 */
- (void) requestDidSend: (ASIFormDataRequest*) request
                  method: (NSString*) method
               arguments: (NSDictionary*) arguments;

@required
/**
 * Adjust the request object according to this call protocol.
 *
 * @param request The request object.
 * @param method The method name.
 * @param arguments The arguments for the call.
 */
- (void) adjustRequest: (ASIFormDataRequest*) request
                method: (NSString*) method
             arguments: (NSDictionary*) arguments;

@optional
/**
 * Whether the call protocol is asynchronous
 *
 * @return the call protocol is asynchronous or not, defaults to YES
 */
- (BOOL) isAsynchronous;

@end

/**
 * Handles call results in WIRemoting framework.
 */
@protocol RMResultDelegate <NSObject>

@required
/**
 * An event fired when the call successfully finishes.
 *
 * @param response A response object from the remote call.
 */
- (void) finished: (RMResponse*) response;

@required
/**
 * An event fired when the call fails.
 *
 * @param response A response object from the remote peer.
 * @param error An error object from the remote peer.
 */
- (void) failed: (RMResponse*) response
              error: (NSError*) error;

@end

/**
 * Handles calls in WIRemoting framework.
 */
@interface RMCall : NSObject {
  id<RMCallProtocol> protocol;
  NSMutableArray *protocolStack;
  NSMutableArray *responseQueue;
  NSMutableArray *delegateChain;
  NSAutoreleasePool *autoReleasePool;
}

/**
 * A call protocol to adjust HTTP requests.
 */
@property(readonly) id<RMCallProtocol> protocol;
/**
 * A semaphore for locking
 */
@property(readonly,getter=semaphore) id semaphore;

/**
 * Initiatize the call with a call protocol.
 *
 * @param protocol A call protocol.
 */
- (id)initWithProtocol: (id<RMCallProtocol>) protocol;

/**
 * Call a remote method.
 *
 * @param method The method name.
 * @param arguments The method arguments.
 *
 * @return whether the call is sent.
 */
- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments;

/**
 * Call a remote method with a specific call protocol.
 *
 * Call a remote method with the specified call protocol in the highest
 * priority.
 *
 * @param method The method name.
 * @param arguments The method arguments.
 * @param protocl The call protocol to execute on top of other protocols.
 *
 * @return whether the call is sent.
 */
- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
    protocol:(id<RMCallProtocol>) protocol;

/**
 * Push a call protocol onto the protocol stack.
 *
 * @param protocol A call protocol.
 */
- (void) pushProtocol: (id<RMCallProtocol>) protocol;
/**
 * Pop a call protocol from the protocol stack.
 *
 * @return The popped call protocol.
 */
- (id<RMCallProtocol>) popProtocol;
/**
 * Get the protocol on the top of the protocol stack.
 *
 * @return The protocol on the top of the stack.
 */
- (id<RMCallProtocol>) topProtocol;

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
