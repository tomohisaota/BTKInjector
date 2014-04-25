//
//  BTKInjectorDuckTypingTests.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/25.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTKInjector.h"
#import "BTKTestProtocol.h"
#import "BTKTestProtocol1Impl.h"
#import "BTKInjectorProtocolOverrideProxy.h"

@interface BTKInjectorDuckTypingTests : XCTestCase

@end

@implementation BTKInjectorDuckTypingTests

- (void)testWithoutDuckTyping
{
    @try {
        id<BTKInjector> injector = [BTKGlobalInjector injectorWithBlock:^(id<BTKMutableInjector> mInjector) {
           [mInjector bindProtocol:@protocol(BTKTestProtocol4)
                   toProviderBlock:^id(id<BTKInjector> injector) {
                       return [BTKTestProtocol1Impl new];
                   }];
        }];
        [injector instanceFor:@protocol(BTKTestProtocol4)];
    }
    @catch (NSException *exception) {
        XCTAssertTrue(([exception.reason rangeOfString:@"does not conforms"].location != NSNotFound) ,
                      @"Exception type is not correct %@",exception);
        return;
    }
    XCTFail(@"Circular Reference was not detected");
}

- (void)testWithDuckTyping
{
    id<BTKInjector> injector = [BTKGlobalInjector injectorWithBlock:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKTestProtocol4)
                   forceConform:YES
                toProviderBlock:^id(id<BTKInjector> injector) {
                    return [BTKTestProtocol1Impl new];
                }];
    }];
    [injector instanceFor:@protocol(BTKTestProtocol4)];
}

@end
