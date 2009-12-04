//
//  RMCall.m
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "WIRemoting.h"

@interface RMCall (Private)
- (void)responseDone:(RMResponse*) response;
@end

@implementation RMCall (Private)

- (void)responseDone:(RMResponse*) response
{
  [responseQueue removeObject: response];
}

@end


@implementation RMCall

@synthesize protocol;

- (id)initWithProtocol: (id<RMCallProtocol>) proto
{
  // pre-condition: protocol must exist
  assert(proto != nil);
  
  // initialize
  self = [super init];
  
  if (nil != self) {
    // assign the instance variable with protocol
    protocol = [proto retain];
    // initialize the protocol stack
    protocolStack = [[NSMutableArray alloc] initWithCapacity:3];
    // push the base protocol to the protocol stack
    [protocolStack addObject:proto];
    // response queue
    responseQueue = [[NSMutableArray alloc] initWithCapacity:3];
    // initialize the auto release pool
    autoReleasePool = [[NSAutoreleasePool alloc] init];
  }
  
  return self;
}

- (void)dealloc
{
  // release protocol stack
  [protocolStack removeAllObjects];
  [protocolStack release];
  // release the protocol
  [protocol release];
  // auto release pool
  [autoReleasePool release];
  // run super's dealloc
  [super dealloc];
}

- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
    delegate:(id<RMResultDelegate>) delegate
{
  return [self call:method
          arguments:arguments
           delegate:delegate
           protocol:nil];
}

- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
    delegate:(id<RMResultDelegate>) delegate
    protocol:(id<RMCallProtocol>) aProtocol
{
  BOOL agreement;
  
  // make sure method and delegate exist
  assert(method != nil);
  assert(delegate != nil);
  
  // generate the request
  ASIFormDataRequest *req = [ASIFormDataRequest
                             requestWithURL:
                             [NSURL URLWithString:@"http://127.0.0.1/"]];
  
  // adjust the request according to protocols
  for (id<RMCallProtocol> proto in protocolStack) {
    [proto adjustRequest:req
                  method:method
               arguments:arguments];
  }
  // top protocol
  if (nil != aProtocol) {
    [aProtocol adjustRequest:req
                      method:method
                   arguments:arguments];
  }
  
  // check with the protocols if the request should be sent
  agreement = YES;
  for (id<RMCallProtocol> proto in protocolStack) {
    if ([proto respondsToSelector:@selector(requestShouldSend:method:arguments:)]) {
      agreement &= [proto requestShouldSend:req
                                     method:method
                                  arguments:arguments];
    }
  }
  
  if (nil != aProtocol) {
    if ([aProtocol respondsToSelector:
         @selector(requestShouldSend:method:arguments:)]) {
      agreement &= [aProtocol requestShouldSend:req
                                         method:method
                                      arguments:arguments];
    }
  }
  
  // not agree
  if (!agreement) {
    return NO;
  }
  
  // notice all protocols that the request is being sent
  for (id<RMCallProtocol> proto in protocolStack) {
    if ([proto respondsToSelector:
         @selector(requestWillSend:method:arguments:)]) {
      [proto requestWillSend:req
                      method:method
                   arguments:arguments];
    }
  }
  
  if (nil != aProtocol) {
    if ([aProtocol respondsToSelector:
         @selector(requestWillSend:method:arguments:)]) {
      [aProtocol requestWillSend:req
                          method:method
                       arguments:arguments];
    }
  }
  
  // create new response
  RMResponse *response = [RMResponse responseWithCall:self
                                              request:req
                                             delegate:delegate];
  
  // enqueue the response
  [responseQueue addObject:response];
  
  // set the delegate
  [req setDelegate:response];
  
  BOOL async = YES;
  
  for (id<RMCallProtocol> proto in protocolStack) {
    if ([proto respondsToSelector:
         @selector(isAsynchronous)]) {
      async = [proto isAsynchronous];
    }
  }
  
  if ([aProtocol respondsToSelector:
       @selector(isAsynchronous)]) {
    async = [aProtocol isAsynchronous];
  }
  
  // send the request asynchronously
  if (async) {
    [req startAsynchronous];
  }
  else {
    [req start];
  }

  // notice all protocols that the request is sent
  for (id<RMCallProtocol> proto in protocolStack) {
    if ([proto respondsToSelector:
         @selector(requestDidSend:method:arguments:)]) {
      [proto requestDidSend:req
                     method:method
                  arguments:arguments];
    }
  }
  
  if (nil != aProtocol) {
    if ([aProtocol respondsToSelector:
         @selector(requestDidSend:method:arguments:)]) {
      [aProtocol requestDidSend:req
                         method:method
                      arguments:arguments];
    }
  }
  
  return YES;
}

- (void)pushProtocol:(id<RMCallProtocol>)proto
{
  [protocolStack addObject:proto];
}

- (id<RMCallProtocol>)popProtocol
{
  id proto = [[protocolStack lastObject] retain];
  [protocolStack removeLastObject];
  return [proto autorelease];
}

- (id<RMCallProtocol>)topProtocol
{
  return [protocolStack lastObject];
}

@end
