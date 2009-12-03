//
//  RMCallTests.m
//  WIRemoting
//
//  Created by Yuxing Huang on 09-11-14.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "RMCallTests.h"
#import "RMCall.h"
#import "MockupProtocol.h"
#import "MockProtocol2.h"
#import "Mock.h"
#import "JSON.h"

@implementation RMCallTests

#pragma mark test set up

- (void) setUp
{
  protocol = [[MockupProtocol alloc] init];
  call = [[RMCall alloc] initWithProtocol:protocol];
}

- (void) tearDown
{
  [call release];
  [protocol release];
}

#pragma mark unit tests

- (void) testSingleProtocol {
  Mock *m = [[Mock alloc] initWithObject:self
                                finished:@selector(callEchoFinished:)
                                  failed:@selector(callFailed:error:)];
  [call call:@"echo" arguments:
   [NSDictionary
    dictionaryWithObjectsAndKeys:
    @"hello world", @"echo",
    nil] delegate:m];
  
  [m release];
}

- (void) testMultipleProtocols
{
  Mock *m = [[Mock alloc] initWithObject:self
                                finished:@selector(callMultipleJsonEchoFinished:)
                                  failed:@selector(callFailed:error:)];
  MockProtocol2 *proto2 = [[MockProtocol2 alloc] init];
  
  [call pushProtocol:proto2];
  // protocol 2 will change _method to json_echo2
  
  [call call:@"echo" arguments:
   [NSDictionary
    dictionaryWithObjectsAndKeys:
    @"hello world", @"echo",
    @"hello world 2", @"echo2",
    nil] delegate:m];
  
  [proto2 release];
  [m release];
  
  // get the top protocol. the top protocol should be MockProtocol2
  STAssertTrue([[call topProtocol] isKindOfClass:[MockProtocol2 class]],
               @"The top protocol is expected to be MockProtocol2, but it is %@.",
               [MockProtocol2 class]);
  
  // pop the protocol out then it should behave with only one protocol
  [call popProtocol];
  
  m = [[Mock alloc] initWithObject:self
                                finished:@selector(callEchoFinished:)
                                  failed:@selector(callFailed:error:)];
  [call call:@"echo" arguments:
   [NSDictionary
    dictionaryWithObjectsAndKeys:
    @"hello world", @"echo",
    nil] delegate:m];
  
  [m release];
}

- (void) testStraightCall
{
  Mock *m = [[Mock alloc] initWithObject:self
                                finished:@selector(callMultipleJsonEchoFinished:)
                                  failed:@selector(callFailed:error:)];
  MockProtocol2 *proto2 = [[MockProtocol2 alloc] init];
  
  // protocol 2 will change _method to json_echo2
  [call call:@"echo"
   arguments:[NSDictionary
              dictionaryWithObjectsAndKeys:
              @"hello world", @"echo",
              @"hello world 2", @"echo2",
              nil]
    delegate:m
    protocol:proto2];
  
  [proto2 release];
  [m release];
}

#pragma mark assistant methods

- (void) callMultipleJsonEchoFinished:(RMResponse *) response
{
  id obj = [[response responseString] JSONValue];
  if (nil != obj && [obj isKindOfClass:[NSDictionary class]]) {
    STAssertTrue([[obj valueForKey:@"echo"] isEqual:@"hello world"],
                 @"Call json_echo2 should receive what we sent, but \"%@\" received",
                 [obj valueForKey:@"echo"]);
    STAssertTrue([[obj valueForKey:@"echo2"] isEqual:@"hello world 2"],
                 @"Call json_echo2 should receive what we sent, but \"%@\" received",
                 [obj valueForKey:@"echo2"]);
  }
  else {
    STFail(@"The response should contain a dictionary object.");
  }
}

- (void) callEchoFinished:(RMResponse *) response
{
  STAssertTrue([[response responseString]
                isEqualToString:@"hello world"],
                 @"Call Echo should receive what we sent, but \"%@\" received.",
                [response responseString]);
}

- (void) callFailed:(RMResponse *) response
              error:(NSError *) error
{
  NSLog(@"%@\n", [error localizedFailureReason]);
  NSLog(@"%@\n", [response responseString]);
  STFail([error localizedFailureReason]);
}

@end
