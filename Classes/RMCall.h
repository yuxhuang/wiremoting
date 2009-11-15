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

/**
 * Provides call protocol interface/implementation.
 */
@protocol RMCallProtocol

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
- (BOOL) requestShouldSend: (ASIHTTPRequest*) request
                    method: (NSString*) method
                 arguments: (RMArguments*) arguments;

@optional
/**
 * An event fired just before the request is sent.
 *
 * @param request The request object.
 * @param method The method name.
 * @param arguments The arguments for the call.
 */
- (void) requestWillSend: (ASIHTTPRequest*) request
                  method: (NSString*) method
               arguments: (RMArguments*) arguments;

@optional
/**
 * An event fired just after the request is sent.
 *
 * @param request The request object.
 * @param method The method name.
 * @param arguments The arguments for the call.
 */
- (void) requestSent: (ASIHTTPRequest*) request
                  method: (NSString*) method
               arguments: (RMArguments*) arguments;

@optional
/**
 * Should the request be adjusted?
 *
 * @param request The request object.
 * @param method The method name.
 * @param arguments The arguments for the call.
 *
 * @return Whether this request should be adjusted.
 */
- (void) requestWillAdjust: (ASIHTTPRequest*) request
                    method: (NSString*) method
                 arguments: (RMArguments*) arguments;

@required
/**
 * Adjust the request object according to this call protocol.
 *
 * @param request The request object.
 * @param method The method name.
 * @param arguments The arguments for the call.
 */
- (void) adjustRequest: (ASIHTTPRequest*) request
                method: (NSString*) method
             arguments: (RMArguments*) arguments;

@end

/**
 * Handles call results in WIRemoting framework.
 */
@protocol RMCallDelegate

@required
/**
 * An event fired when the call successfully finishes.
 *
 * @param response A response object from the remote call.
 */
- (void) callFinished: (RMResponse*) response;

@required
/**
 * An event fired when the call fails.
 *
 * @param response A response object from the remote peer.
 * @param error An error object from the remote peer.
 */
- (void) callFailed: (RMResponse*) response
              error: (RMError*) error;

@end

/**
 * Handles calls in WIRemoting framework.
 */
@interface RMCall : NSObject {
  id<RMCallProtocol> protocol;
  NSMutableArray *protocolStack;
}

/**
 * A call protocol to adjust HTTP requests.
 */
@property(retain) id<RMCallProtocol> protocol;

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
 * @param delegate The call delegate to handle results.
 */
- (void)call:(NSString*) method
   arguments:(RMArguments*) arguments
    delegate:(id<RMCallDelegate>) delegate;

/**
 * Call a remote method with a specific call protocol.
 *
 * Call a remote method with the specified call protocol in the highest
 * priority.
 *
 * @param method The method name.
 * @param arguments The method arguments.
 * @param delegate The call delegate to handle results.
 * @param protocl The call protocol to execute on top of other protocols.
 */
- (void)call:(NSString*) method
   arguments:(RMArguments*) arguments
    delegate:(id<RMCallDelegate>) delegate
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

@end
