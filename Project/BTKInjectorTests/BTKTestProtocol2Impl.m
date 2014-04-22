//
//  BTKTestProtocol2Impl.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKTestProtocol2Impl.h"

@implementation BTKTestProtocol2Impl{
    id<BTKTestProtocol1> _protocol1;
    id<BTKTestProtocol3> _protocol3;
}

@synthesize protocol1Provider = _protocol1Provider;
@synthesize protocol3Provider = _protocol3Provider;

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

-(NSString*)test2
{
    return @"test2";
}

@end
