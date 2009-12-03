//
//  RMResponse.m
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "RMResponse.h"
#import "RMCall.h"
#import "ASIHTTPRequest.h"

@interface RMCall (Private)
- (void)responseDone:(RMResponse*) response;
@end

@implementation RMResponse


+ (id)responseWithCall:(RMCall*) call
               request:(ASIHTTPRequest*) request
              delegate:(id<RMCallDelegate>) delegate
{
  return [[[RMResponse alloc]
           initWithCall:call request:request delegate:delegate] autorelease];
}

- (id)initWithCall:(RMCall*) call
           request:(ASIHTTPRequest*) req
          delegate:(id<RMCallDelegate>) aDelegate
{
  self = [super init];
  
  if (nil != self) {
    parentCall = call;
    request = [req retain];
    delegate = aDelegate;
  }
  
  return self;
}

- (void)dealloc
{
  [string release];
  [data release];
  [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest*) req
{
  // get the response
  string = [[NSString alloc] initWithString:[req responseString]];
  data = [[NSData alloc] initWithData:[req responseData]];
  
  // call the delegate for successful call
  [delegate callFinished:self];
  
  // tell the parent call the response is done
  [parentCall responseDone:self];
}

- (void)requestFailed:(ASIHTTPRequest*) req
{
  // get the response
  string = [[NSString alloc] initWithString:[req responseString]];
  data = [[NSData alloc] initWithData:[req responseData]];
  NSError *error = [req error];
  
  // call the delegate for failed call
  [delegate callFailed:self
                 error:error];
  
  // tell the parent call the response is done
  [parentCall responseDone:self];
}

- (NSString*) responseString
{
  return string;
}

- (NSData*) responseData
{
  return data;
}

@end
