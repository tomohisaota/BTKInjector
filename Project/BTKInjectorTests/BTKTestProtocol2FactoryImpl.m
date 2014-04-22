//
//  BTKTestProtocol2Factory.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKTestProtocol2FactoryImpl.h"
#import "BTKInjector.h"
#import "BTKTestProtocol2Impl.h"

@implementation BTKTestProtocol2FactoryImpl

- (id)init
{
    return [super initWithProtocol:@protocol(BTKTestProtocol2)];
}

- (id<BTKTestProtocol2>) protocol2WithString : (NSString*) str;
{
    BTKTestProtocol2Impl *o = [BTKTestProtocol2Impl new];
    o.protocol1Provider = [self.injector providerForProtocol:@protocol(BTKTestProtocol1)];
    o.protocol3Provider = [self.injector providerForProtocol:@protocol(BTKTestProtocol3)];
    return o;
}

@end
