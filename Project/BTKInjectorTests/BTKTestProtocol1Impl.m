//
//  BTKTestProtocol1Impl.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKTestProtocol1Impl.h"

@implementation BTKTestProtocol1Impl{
    id<BTKTestProtocol2> _protocol2;
    id<BTKTestProtocol3> _protocol3;
}

@synthesize protocol2Provider = _protocol2Provider;
@synthesize protocol3Provider = _protocol3Provider;

- (id<BTKTestProtocol2>)protocol2
{
    if(_protocol2 == nil){
        _protocol2 = self.protocol2Provider.get;
    }
    return _protocol2;
}

- (void)setProtocol2:(id<BTKTestProtocol2>)protocol2
{
    _protocol2 = protocol2;
}

- (id<BTKTestProtocol3>)protocol3
{
    if(_protocol3 == nil){
        _protocol3 = self.protocol3Provider.get;
    }
    return _protocol3;
}

- (void)setProtocol3:(id<BTKTestProtocol3>)protocol3
{
    _protocol3 = protocol3;
}

- (NSString *)test1
{
    return @"test1";
}

@end
