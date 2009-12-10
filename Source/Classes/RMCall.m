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
@dynamic semaphore;

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
    // delegate chain
    delegateChain = [[NSMutableArray alloc] initWithCapacity:1];
    // initialize the auto release pool
    autoReleasePool = [[NSAutoreleasePool alloc] init];
  }
  
  return self;
}

- (void)dealloc
{
  // release protocol stack
  [protocolStack release];
  // release the protocol
  [protocol release];
  // auto release pool
  [autoReleasePool release];
  // delegate chain
  [delegateChain release];
  // run super's dealloc
  [super dealloc];
}

- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
{
  return [self call:method
          arguments:arguments
           protocol:nil];
}

- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
    delegate:(id) delegate
{
  BOOL r;
  @synchronized(self.semaphore) {
    [self addDelegate:delegate];
    r = [self call:method arguments:arguments];
    [self removeDelegate:delegate];
  }
  return r;
}

- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
    delegate:(id) delegate
    protocol:(id<RMCallProtocol>) aProtocol
{
  BOOL r;
  @synchronized(self.semaphore) {
    [self addDelegate:delegate];
    r = [self call:method arguments:arguments protocol:aProtocol];
    [self removeDelegate:delegate];
  }
  return r;
}

- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
    protocol:(id<RMCallProtocol>) aProtocol
{

  BOOL agreement;
  
  // make sure method and delegate exist
  assert(method != nil);
  if (nil == arguments) {
    arguments = [[NSDictionary alloc] init];
  }
  else {
    [arguments retain];
  }
  
  @synchronized(self.semaphore) {
    
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
      [arguments release];
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
                                               delegate:delegateChain];
    
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
  }

  [arguments release];
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

- (void) addDelegate: (id<RMResultDelegate>) delegate
{
  @synchronized(self.semaphore) {
    [delegateChain addObject:delegate];
  }
}

- (void) removeDelegate: (id<RMResultDelegate>) delegate
{
  @synchronized(self.semaphore) {
    [delegateChain removeObject:delegate];
  }
}

- (id) semaphore
{
  return self;
}

@end
