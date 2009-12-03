//
//  RMResponse.h
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMCall;
@class ASIHTTPRequest;
@protocol RMCallDelegate;

/**
 * Handles call responses in WIRemoting framework.
 */
@interface RMResponse : NSObject {
  RMCall *parentCall;
  id<RMCallDelegate> delegate;
  ASIHTTPRequest *request;
  NSString *string;
  NSData *data;
}


+ (id)responseWithCall:(RMCall*) call
               request:(ASIHTTPRequest*) request
              delegate:(id<RMCallDelegate>) delegate;

- (id)initWithCall:(RMCall*) call
           request:(ASIHTTPRequest*) request
          delegate:(id<RMCallDelegate>) delegate;

- (void)requestFinished:(ASIHTTPRequest*) request;
- (void)requestFailed:(ASIHTTPRequest*) request;

- (NSString*) responseString;
- (NSData*) responseData;

@end
