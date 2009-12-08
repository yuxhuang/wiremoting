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
    sessionKey = nil;
    client = -1;
  }
  
  return self;
}

- (void) clear
{
  client = -1;
  [sessionKey release];
  sessionKey = nil;
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
        [[message valueForKey:@"string"] isEqual:@"Invalid username and / or password."]) {
      return NO;
    }
    else {
      return YES;
    }
  }

  return NO;
}

- (void) adjustRequest:(ASIFormDataRequest *)request
                method:(NSString *)method
             arguments:(NSDictionary *)arguments
{
  // adjust request to add client and sessionKey
  if (client != -1 && nil != sessionKey) {
    [request setPostValue:[NSNumber numberWithInt:client] forKey:@"client"];
    [request setPostValue:sessionKey forKey:@"sessionkey"];
  }
}

#pragma mark authentication token

- (void) getAuthenticationToken: (RMResponse*) response
{
  if (nil != sessionKey) {
    [sessionKey release];
    sessionKey = nil;
    client = -1;
  }
  
  id r = [[response responseString] JSONValue];
  if (nil != r && [r isKindOfClass:[NSDictionary class]]) {
    NSNumber *n = (NSNumber*) [r valueForKey:@"client"];
    sessionKey = [[r valueForKey:@"sessionkey"] copy];;
    if (nil != n && nil != sessionKey) {
      client = [n intValue];
    }
  }
  
}

- (void) failed:(RMResponse*) response error:(NSError*) error
{
  [sessionKey release];
  sessionKey = nil;
  client = -1;
}

@end
