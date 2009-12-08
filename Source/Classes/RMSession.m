//
//  RMSession.m
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "WIRemoting.h"

@implementation RMSession

@synthesize call, authenticated;
@dynamic semaphore;

#pragma mark session management

- (id) initWithAuthenticator: (id<RMAuthenticator>) newAuthenticator
                        call:(RMCall*) newCall
{
  self = [super init];
  if (nil != self) {
    // grab instances
    authenticator = [newAuthenticator retain];
    call = [newCall retain];
    delegateChain = [[NSMutableArray alloc] initWithCapacity:1];
    
    // initialize variables
    authenticated = NO;
    
  }
  return self;
}

- (void) dealloc
{
  [authenticator release];
  [call release];
  [delegateChain release];
  [super dealloc];
}

- (void) close {
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

#pragma mark authentication

- (void) authenticate
{
  @synchronized(self.call.semaphore) {
    [self.call addDelegate:self];
    [authenticator authenticateWithCall:self.call];
    [self.call removeDelegate:self];
  }
}

- (void)finished:(RMResponse *)response
{
  BOOL auth = NO;
  // check responseString
  if ([authenticator
       respondsToSelector:@selector(authenticateResponseString:)]) {
    if ([authenticator authenticateResponseString:[response responseString]]) {
      auth = YES;
    }
  }
  // check responseData
  if ([authenticator
       respondsToSelector:@selector(authenticateResponseData:)]) {
    if ([authenticator authenticateResponseData:[response responseData]]) {
      auth = YES;
    }
  }
  // if authenticated
  @synchronized(self.semaphore) {
    if (auth) {
      authenticated = YES;
      // call delegates
      for (id<RMResultDelegate> delegate in delegateChain) {
        [delegate finished:response];
      }
    }
    else {
      authenticated = NO;
      // create a new NSError
      NSError *error =
          [NSError errorWithDomain:NSURLErrorDomain
                              code:EINVAL
                          userInfo:
            [NSDictionary
             dictionaryWithObjectsAndKeys:
             @"Authentication error.", NSLocalizedDescriptionKey,
             @"Unable to authenticate the session.", NSLocalizedFailureReasonErrorKey,
             nil]];
      for (id<RMResultDelegate> delegate in delegateChain) {
        [delegate failed:response error:error];
      }
    }
  }
}

- (void)failed:(RMResponse *)response error:(NSError *)error
{
  @synchronized(self.semaphore) {
    for (id<RMResultDelegate> delegate in delegateChain) {
      [delegate failed:response error:error];
    }
  }
}

#pragma mark call

- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
{
  return [call call:method
          arguments:arguments
           protocol:[authenticator callProtocol]];
}

@end
