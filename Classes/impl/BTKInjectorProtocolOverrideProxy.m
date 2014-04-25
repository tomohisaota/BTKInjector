//
//  BTKInjectorDuckProxy.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/25.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorProtocolOverrideProxy.h"

@implementation BTKInjectorProtocolOverrideProxy{
    id _target;
    Protocol *_protocol;
}

- (instancetype) initWithTarget : (id) target
                       protocol : (Protocol*)protocol
{
    _target = target;
    _protocol = protocol;
    return self;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    if(aProtocol == _protocol){
        return YES;
    }
    return [super conformsToProtocol:aProtocol];
}

-(void)forwardInvocation:(NSInvocation *)invocation {
	[invocation invokeWithTarget:_target];
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    return [_target methodSignatureForSelector:selector];
}

@end
