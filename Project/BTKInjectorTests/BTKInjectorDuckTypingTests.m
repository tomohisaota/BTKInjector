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
#import "BTKInjectorProxyProtocolOverride.h"

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
        id<BTKTestProtocol4> obj = [injector proxyFor:@protocol(BTKTestProtocol4)];
        [obj test1];
    }
    @catch (NSException *exception) {
        XCTAssertTrue(([exception.reason rangeOfString:@"does not conforms"].location != NSNotFound) ,
                      @"Exception type is not correct %@",exception);
        return;
    }
    XCTFail(@"Protocol mismatch did not detected");
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
    [injector proxyFor:@protocol(BTKTestProtocol4)];
}

@end
