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

+ (void)setUp
{
    [super setUp];
    [BTKGlobalInjector removeGlobalInjector];
    [BTKGlobalInjector setupGlobalInjector:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKTestProtocol1)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol1Impl *o = [BTKTestProtocol1Impl new];
                    o.protocol2Provider = [i providerForProtocol:@protocol(BTKTestProtocol2)];
                    return o;
                }];
        [mInjector bindProtocol:@protocol(BTKTestProtocol2)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol2Impl *o = [BTKTestProtocol2Impl new];
                    o.protocol3Provider = [i providerForProtocol:@protocol(BTKTestProtocol3)];
                    return o;
                }];
        [mInjector bindProtocol:@protocol(BTKTestProtocol3)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol3Impl *o = [BTKTestProtocol3Impl new];
                    return o;
                }];
    }];
}

- (void)testGlobalInjector
{
    id<BTKTestProtocol1> o = [[BTKGlobalInjector get]instanceForProtocol:@protocol(BTKTestProtocol1)];
    XCTAssertEqual(@"test1", o.test1);
    XCTAssertEqual(@"test2", o.protocol2.test2);
    XCTAssertEqual(@"test3", o.protocol2.protocol3.test3);
    
    XCTAssertTrue(o.protocol2Provider.get == o.protocol2);
    XCTAssertTrue(o.protocol2Provider.get.protocol3Provider.get == o.protocol2.protocol3);
}

- (void) testCircularReferenceWithInstance
{
    @try {
        id<BTKInjector> injector = [BTKGlobalInjector injectorWithBlock:^(id<BTKMutableInjector> mInjector) {
            [mInjector bindProtocol:@protocol(BTKTestProtocol1)
                    toProviderBlock:^id(id<BTKInjector> i) {
                        BTKTestProtocol1Impl *o = [BTKTestProtocol1Impl new];
                        o.protocol2 = [i instanceForProtocol:@protocol(BTKTestProtocol2)];
                        return o;
                    }];
            [mInjector bindProtocol:@protocol(BTKTestProtocol2)
                    toProviderBlock:^id(id<BTKInjector> i) {
                        BTKTestProtocol2Impl *o = [BTKTestProtocol2Impl new];
                        o.protocol3 = [i instanceForProtocol:@protocol(BTKTestProtocol3)];
                        return o;
                    }];
            [mInjector bindProtocol:@protocol(BTKTestProtocol3)
                    toProviderBlock:^id(id<BTKInjector> i) {
                        BTKTestProtocol3Impl *o = [BTKTestProtocol3Impl new];
                        o.protocol1 = [i instanceForProtocol:@protocol(BTKTestProtocol1)];
                        return o;
                    }];
        }];
        id<BTKTestProtocol1> o = [injector instanceForProtocol:@protocol(BTKTestProtocol1)];
        XCTAssertEqual(@"test1", o.test1);
        XCTAssertEqual(@"test2", o.protocol2.test2);
        XCTAssertEqual(@"test3", o.protocol2.protocol3.test3);
        XCTAssertEqual(@"test1", o.protocol2.protocol3.protocol1.test1);
    }
    @catch (NSException *exception) {
        XCTAssertTrue(([exception.reason rangeOfString:@"Circular reference detected"].location != NSNotFound) ,
                      @"Exception type is not correct %@",exception);
        return;
    }
    XCTFail(@"Circular Reference was not detected");
}

- (void) testCircularReferenceWithProvider
{
    id<BTKInjector> injector = [BTKGlobalInjector injectorWithBlock:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKTestProtocol1)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol1Impl *o = [BTKTestProtocol1Impl new];
                    o.protocol2Provider = [i providerForProtocol:@protocol(BTKTestProtocol2)];
                    return o;
                }];
        [mInjector bindProtocol:@protocol(BTKTestProtocol2)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol2Impl *o = [BTKTestProtocol2Impl new];
                    o.protocol3Provider = [i providerForProtocol:@protocol(BTKTestProtocol3)];
                    return o;
                }];
        [mInjector bindProtocol:@protocol(BTKTestProtocol3)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol3Impl *o = [BTKTestProtocol3Impl new];
                    o.protocol1Provider = [i providerForProtocol:@protocol(BTKTestProtocol1)];
                    return o;
                }];
    }];
    id<BTKTestProtocol1> o = [injector instanceForProtocol:@protocol(BTKTestProtocol1)];
    XCTAssertEqual(@"test1", o.test1);
    XCTAssertEqual(@"test2", o.protocol2.test2);
    XCTAssertEqual(@"test3", o.protocol2.protocol3.test3);
    XCTAssertEqual(@"test1", o.protocol2.protocol3.protocol1.test1);
}

@end
