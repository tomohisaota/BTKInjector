//
//  BTKInjectorKVC.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/25.
//  Copyright (c) 2014年 Tomohisa Ota. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTKInjector.h"
#import "BTKTestProtocol.h"
#import "BTKTestProtocol1Impl.h"


@interface BTKInjectorKVC : XCTestCase

@end

@implementation BTKInjectorKVC

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDirectKVC
{
    BTKTestProtocol1Impl *imp = [BTKTestProtocol1Impl new];
    XCTAssertEqual(@"test1", imp.test1);
    XCTAssertEqual(@"test1", [imp valueForKey:@"test1"]);
}

- (void)testInstanceKVC
{
    id<BTKInjector> injector = [BTKGlobalInjector injectorWithBlock:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKTestProtocol1)
                toProviderBlock:^id(id<BTKInjector> injector) {
                    return [BTKTestProtocol1Impl new];
                }];
    }];
    
    NSObject<BTKTestProtocol1> *imp = [injector instanceFor:@protocol(BTKTestProtocol1)];
    XCTAssertEqual(@"test1", imp.test1);
    XCTAssertEqual(@"test1", [imp valueForKey:@"test1"]);
}

- (void)testProxyKVC
{
    id<BTKInjector> injector = [BTKGlobalInjector injectorWithBlock:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKTestProtocol1)
                toProviderBlock:^id(id<BTKInjector> injector) {
                    return [BTKTestProtocol1Impl new];
                }];
    }];
    
    NSObject<BTKTestProtocol1> *imp = [injector proxyFor:@protocol(BTKTestProtocol1)];
    XCTAssertEqual(@"test1", imp.test1);
    XCTAssertEqual(@"test1", [imp valueForKey:@"test1"]);
}

@end
