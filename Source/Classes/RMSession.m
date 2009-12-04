//
//  RMSession.m
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "WIRemoting.h"

@implementation RMSession

@synthesize call, delegate, authenticated;

#pragma mark session management

- (id) initWithAuthenticator: (id<RMAuthenticator>) newAuthenticator
                        call:(RMCall*) newCall
                    delegate: (id<RMResultDelegate>) newDelegate
{
  self = [super init];
  if (nil != self) {
    // grab instances
    authenticator = [newAuthenticator retain];
    call = [newCall retain];
    delegate = [newDelegate retain];
    
    // initialize variables
    authenticated = NO;
    
  }
  return self;
}

- (void) dealloc
{
  [authenticator release];
  [call release];
  [delegate release];
  [super dealloc];
}

- (void) close {
}

#pragma mark authentication

- (void) authenticate
{
  [authenticator authenticateWithCall:self.call delegate:self];
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
  if (auth) {
    authenticated = YES;
    // call delegate
    [delegate finished:response];
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
    [delegate failed:response error:error];
  }
}

- (void)failed:(RMResponse *)response error:(NSError *)error
{
  [delegate failed:response error:error];
}

#pragma mark call

- (BOOL)call:(NSString*) method
   arguments:(NSDictionary*) arguments
    delegate:(id<RMResultDelegate>) callDelegate
{
  return [call call:method
          arguments:arguments
           delegate:callDelegate
           protocol:[authenticator callProtocol]];
}

@end
