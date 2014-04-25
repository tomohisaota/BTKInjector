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
