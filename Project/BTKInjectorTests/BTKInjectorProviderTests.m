//
//  BTKInjectorTests.m
//  BTKInjectorTests
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTKInjector.h"
#import "BTKTestProtocol.h"
#import "BTKTestProtocol1Impl.h"
#import "BTKTestProtocol2Impl.h"
#import "BTKTestProtocol3Impl.h"

@interface BTKInjectorProviderTests : XCTestCase

@end

@implementation BTKInjectorProviderTests

- (void) testCircularReferenceWithInstance
{
    id<BTKInjector> injector = [BTKGlobalInjector injectorWithBlock:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKTestProtocol1)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol1Impl *o = [BTKTestProtocol1Impl new];
                    o.protocol2 = [i proxyFor:@protocol(BTKTestProtocol2)];
                    return o;
                }];
        [mInjector bindProtocol:@protocol(BTKTestProtocol2)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol2Impl *o = [BTKTestProtocol2Impl new];
                    o.protocol3 = [i proxyFor:@protocol(BTKTestProtocol3)];
                    return o;
                }];
        [mInjector bindProtocol:@protocol(BTKTestProtocol3)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol3Impl *o = [BTKTestProtocol3Impl new];
                    o.protocol1 = [i proxyFor:@protocol(BTKTestProtocol1)];
                    return o;
                }];
    }];
    id<BTKTestProtocol1> o = [injector proxyFor:@protocol(BTKTestProtocol1)];
    XCTAssertTrue([o conformsToProtocol:@protocol(BTKTestProtocol1)]);
    XCTAssertTrue([o.protocol2 conformsToProtocol:@protocol(BTKTestProtocol2)]);
    XCTAssertTrue([o.protocol2.protocol3 conformsToProtocol:@protocol(BTKTestProtocol3)]);
    XCTAssertEqual(@"test1", o.test1);
    XCTAssertEqual(@"test2", o.protocol2.test2);
    XCTAssertEqual(@"test3", o.protocol2.protocol3.test3);
    XCTAssertEqual(@"test1", o.protocol2.protocol3.protocol1.test1);
}

@end
