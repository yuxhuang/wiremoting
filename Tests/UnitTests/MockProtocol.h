//
//  TestProtocol.h
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-15.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIRemoting.h"

@interface MockProtocol : NSObject<RMCallProtocol> {
  
}

- (void) adjustRequest:(ASIHTTPRequest *)request
                method:(NSString *)method
             arguments:(NSDictionary *)arguments;

@end
