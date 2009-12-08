//
//  MoodleAuthenticator.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-03.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "MoodleAuthenticator.h"
#import "WIRemoting.h"

@implementation MoodleAuthenticator

- (id)initWithUsername:(NSString*)aUsername
              password:(NSString *)aPassword
{
  self = [super init];
  
  if (nil != self) {
    wrapper = [[RMResultDelegateWrapper alloc]
               initWithObject:self
                     finished:@selector(getAuthenticationToken:)
                       failed:@selector(failed:error:)];
    
    username = [aUsername copy];
    password = [aPassword copy];
  }
  
  return self;
}

- (void) dealloc
{
  [wrapper release];
  [super dealloc];
}

- (void) authenticateWithCall:(RMCall *)call
{
  @synchronized(call.semaphore) {
    [call addDelegate:wrapper];
    if ([call call:@"login"
         arguments:[NSDictionary
                    dictionaryWithObjectsAndKeys:
                    username, @"username",
                    password, @"password",
                    nil]]) {
      // you should be here
    }
    else {
      // throw authentication exception
      NSException *e = [NSException exceptionWithName:@"MoodleAuthenticationException"
                                               reason:@"Protocol not allowed."
                                             userInfo:nil];
      @throw e;
    }
    [call removeDelegate:wrapper];
  }
}

- (id<RMCallProtocol>) callProtocol
{
  return self;
}

- (BOOL) authenticateResponseString:(NSString *)responseString
{
  // check the json value
  id r = [responseString JSONValue];
  // check if r is NSDictionary
  if ([r isKindOfClass:[NSDictionary class]]) {
    NSNumber *n = [r valueForKey:@"error"];
    NSDictionary *message = [r valueForKey:@"message"];
    // authentication failure condition
    if (nil != n &&
        [n boolValue] &&
        nil != message &&
        [message isKindOfClass:[NSDictionary class]] &&
        [[message valueForKey:@"code"] isEqual:@"SOAP"] &&
        [[message valueForKey:@"string"] isEqual:@"Invalid username and \\/ or password."]) {
      return FALSE;
    }
    else {
      return TRUE;
    }
  }

  return FALSE;
}

- (void) adjustRequest:(ASIFormDataRequest *)request
                method:(NSString *)method
             arguments:(NSDictionary *)arguments
{
  // adjust request according to 
}

#pragma mark authentication token

- (void) getAuthenticationToken: (RMResponse*) response
{
}

- (void) failed:(RMResponse*) response error:(NSError*) error
{
}

@end
