//
//  RMSessionTests.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "RMSessionTests.h"
#import "MockProtocol.h"
#import "RMResultDelegateWrapper.h"
#import "WIRemoting.h"

@implementation RMSessionTests

#pragma mark initialization

- (void) setUp
{
  RMResultDelegateWrapper *m = [[RMResultDelegateWrapper alloc] initWithObject:self
                                finished:@selector(finished:)
                                  failed:@selector(failed:error:)];
  protocol = [[MockProtocol alloc] init];
  call = [[RMCall alloc] initWithProtocol:protocol];
  session = [[RMSession alloc] initWithAuthenticator:self
                                                call:call
                                            delegate:m];
  username = @"admin";
  password = @"1234";
  [m release];
}

- (void) tearDown
{
  [session release];
  [call release];
  [protocol release];
}

#pragma mark tests

- (void) testSessionAuthentication {
  [session authenticate];
  if (session.authenticated) {
    // should be here
  }
  else {
    STFail(@"Unable to authenticate.");
  }
}

- (void)testFailedAuthentication {
  username = @"abc";
  id<RMResultDelegate> oldDelegate = [session.delegate retain];
  RMResultDelegateWrapper *m = [[RMResultDelegateWrapper alloc] initWithObject:self
                                finished:@selector(finished:)
                                  failed:@selector(expectFailed:error:)];
  session.delegate = m;

  [session authenticate];
  if (session.authenticated) {
    // shouldn't be here, because the authenticat must failed with
    // wrong credentials
    STFail(@"Incorrectly authenticated.");
  }
  else {
    // right
  }
  
  username = @"admin";
  session.delegate = oldDelegate;
  
  [oldDelegate release];
  [m release];
}

- (void)testSessionCall
{
  RMResultDelegateWrapper *m = [[RMResultDelegateWrapper alloc] initWithObject:self
                                finished:@selector(finished:)
                                  failed:@selector(failed:error:)];
  [session call:@"json_echo2"
      arguments:[NSDictionary
                 dictionaryWithObjectsAndKeys:@"hello world", @"echo", nil]
       delegate:m];
  
  [m release];
}

- (void)testNormalCallWithNoAuthenticationInfo
{
  RMResultDelegateWrapper *m = [[RMResultDelegateWrapper alloc] initWithObject:self
                                finished:@selector(finished:)
                                  failed:@selector(expectFailed:error:)];
  [session.call call:@"json_echo2"
      arguments:[NSDictionary
                 dictionaryWithObjectsAndKeys:@"hello world", @"echo", nil]
       delegate:m];
  
  [m release];
}

#pragma mark support functions

- (id<RMCallProtocol>) callProtocol
{
  return self;
}

- (void)authenticateWithCall:(RMCall *)call
                    delegate:(id<RMResultDelegate>)delegate
{
  if ([call call:@"json_auth"
       arguments:[NSDictionary
                  dictionaryWithObjectsAndKeys:
                  username, @"username",
                  password, @"password",
                  nil]
        delegate:delegate]) {
    // should be here
  }
  else {
    STFail(@"The authenticate call is not executed.");
  }
}

- (void)adjustRequest:(ASIFormDataRequest *)request
               method:(NSString *)method
            arguments:(NSDictionary *)arguments
{
  [request setPostValue:username forKey:@"username"];
  [request setPostValue:password forKey:@"password"];
}

- (BOOL)authenticateResponseString:(NSString *)responseString
{
  // check if it is authentication message
  id r = [responseString JSONValue];
  if ([r isKindOfClass:[NSDictionary class]]) {
    NSNumber *auth = [r valueForKey:@"authenticated"];
    // no auth identity, must be correct
    if (nil == auth) {
      return YES;
    }
    
    if ([auth boolValue]) {
      // authenticated
      return YES;
    }
    
    return NO;
  }
  else {
    // wrong response type
    return NO;
  }
}

- (void)finished:(RMResponse *)response
{
}

- (void)expectFailed:(RMResponse*) response error:(NSError*) error
{
  if ([[error domain] isEqual:NSURLErrorDomain] &&
      [error code] == EINVAL) {
    // should be here
  }
  else {
    STFail(@"incorrect failure.");
  }
}

- (void)failed:(RMResponse *)response error:(NSError *)error
{
  STFail(@"Failed request.");
}


@end
