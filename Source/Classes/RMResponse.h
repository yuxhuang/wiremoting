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
@protocol RMResultDelegate;

/**
 * Handles call responses in WIRemoting framework.
 */
@interface RMResponse : NSObject {
  RMCall *parentCall;
  NSArray *delegateChain;
  ASIHTTPRequest *request;
  NSString *string;
  NSData *data;
}


+ (id)responseWithCall:(RMCall*) call
               request:(ASIHTTPRequest*) request
              delegate:(NSArray*) delegateChain;

- (id)initWithCall:(RMCall*) call
           request:(ASIHTTPRequest*) request
          delegate:(NSArray*) delegateChain;

- (void)requestFinished:(ASIHTTPRequest*) request;
- (void)requestFailed:(ASIHTTPRequest*) request;

- (NSString*) responseString;
- (NSData*) responseData;

@end
