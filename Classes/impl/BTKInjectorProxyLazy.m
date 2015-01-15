//
//  BTKInjectorProxy.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/23.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorProxyLazy.h"

@implementation BTKInjectorProxyLazy{
    BTKInjectorProviderBase* _provider;
}

- (instancetype) initWithProvider : (BTKInjectorProviderBase*) provider;
{
    _provider = provider;
    return self;
}

-(void)forwardInvocation:(NSInvocation *)invocation {
	[invocation invokeWithTarget:_provider.get];
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    return [_provider.get methodSignatureForSelector:selector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    // Swift runtime calls conformsToProtocol earlier than Objective C.
    // And it causes circular reference problem.
    // To workaround the issue, skip protocol check for the target protocol.
    // Target protocol is also checked in BTKInjectorProviderBase.
    // So there should not be any side effects.
    if(_provider.targetProtocol == aProtocol){
        return YES;
    }
    return [_provider.get conformsToProtocol:aProtocol];
}

@end
