//
//  BTKInjectorFactoryTests.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTKInjector.h"
#import "BTKTestProtocol.h"
#import "BTKTestProtocol1Impl.h"
#import "BTKTestProtocol2Impl.h"
#import "BTKTestProtocol3Impl.h"
#import "BTKTestProtocol2FactoryImpl.h"

@interface BTKInjectorFactoryTests : XCTestCase

@end

@implementation BTKInjectorFactoryTests

- (void)setUp
{
    [super setUp];
    [BTKGlobalInjector setupGlobalInjector:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKTestProtocol1)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol1Impl *o = [BTKTestProtocol1Impl new];
                    id<BTKTestProtocol2Factory> f = [i factoryForProtocol:@protocol(BTKTestProtocol2)];
                    o.protocol2 = [f protocol2WithString:@"test4"];
                    return o;
                }];
        [mInjector bindFactory:[BTKTestProtocol2FactoryImpl new]];
        [mInjector bindProtocol:@protocol(BTKTestProtocol3)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol3Impl *o = [BTKTestProtocol3Impl new];
                    id<BTKTestProtocol2Factory> f = [i factoryForProtocol:@protocol(BTKTestProtocol2)];
                    o.protocol2 = [f protocol2WithString:@"test4"];
                    return o;
                }];
    }];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGlobalInjector
{
    id<BTKTestProtocol1> o1 = [[BTKGlobalInjector get]instanceForProtocol:@protocol(BTKTestProtocol1)];
    id<BTKTestProtocol3> o3 = [[BTKGlobalInjector get]instanceForProtocol:@protocol(BTKTestProtocol3)];
    
    XCTAssertTrue(o1.protocol2 != o3.protocol2);
}


@end
