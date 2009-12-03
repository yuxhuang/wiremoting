//
//  RMSession.m
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-01.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "RMSession.h"

@implementation RMSession

@synthesize call, delegate;

- (id) initWithAuthenticator: (id<RMAuthenticator>) authenticator
                        call:(RMCall*) call
                    delegate: (id<RMSessionDelegate>) delegate {
  self = [super init];
  return self;
}

- (void) close {
}

@end
