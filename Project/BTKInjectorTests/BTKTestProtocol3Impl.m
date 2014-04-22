//
//  BTKTestProtocol3Impl.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKTestProtocol3Impl.h"

@implementation BTKTestProtocol3Impl{
    id<BTKTestProtocol1> _protocol1;
    id<BTKTestProtocol2> _protocol2;
}

@synthesize protocol1Provider = _protocol1Provider;
@synthesize protocol2Provider = _protocol2Provider;

- (id<BTKTestProtocol1>)protocol1
{
    if(_protocol1 == nil){
        _protocol1 = self.protocol1Provider.get;
    }
    return _protocol1;
}

- (void)setProtocol1:(id<BTKTestProtocol1>)protocol1
{
    _protocol1 = protocol1;
}

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

-(NSString*)test3
{
    return @"test3";
}

@end
