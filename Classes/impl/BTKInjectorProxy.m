//
//  BTKInjectorProxy.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/23.
//  Copyright (c) 2014年 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorProxy.h"

@implementation BTKInjectorProxy{
    id<BTKInjectorProvider> _provider;
}

- (instancetype) initWithProvider : (id<BTKInjectorProvider>) provider
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

@end
