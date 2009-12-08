//
//  RMResponse.m
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "WIRemoting.h"

@interface RMCall (Private)
- (void)responseDone:(RMResponse*) response;
@end

@implementation RMResponse


+ (id)responseWithCall:(RMCall*) call
               request:(ASIHTTPRequest*) request
              delegate:(NSArray*) aDelegateChain
{
  return [[[RMResponse alloc]
           initWithCall:call request:request delegate:aDelegateChain] autorelease];
}

- (id)initWithCall:(RMCall*) call
           request:(ASIHTTPRequest*) req
          delegate:(NSArray*) aDelegateChain
{
  self = [super init];
  
  if (nil != self) {
    parentCall = call;
    request = [req retain];
    // take a snapshot of the delegate chain
    delegateChain = [aDelegateChain copy];;
  }
  
  return self;
}

- (void)dealloc
{
  [string release];
  [data release];
  [delegateChain release];
  [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest*) req
{
  // get the response
  string = [[NSString alloc] initWithString:[req responseString]];
  data = [[NSData alloc] initWithData:[req responseData]];
  
  // call delegates for successful call
  for (id<RMResultDelegate> delegate in delegateChain) {
    [delegate finished:self];
  }
  
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
  for (id<RMResultDelegate> delegate in delegateChain) {
    [delegate failed:self
               error:error];
  }
  
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
