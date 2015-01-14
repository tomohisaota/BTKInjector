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
    if(_provider.targetProtocol == aProtocol){
        return YES;
    }
    return [_provider.get conformsToProtocol:aProtocol];
}

@end
