//
//  BTKMutableInjectorImpl.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKMutableInjectorImpl.h"
#import "BTKInjectorImpl.h"
#import "BTKInjectorProviderBlockImpl.h"

@implementation BTKMutableInjectorImpl{
    NSMutableDictionary *_bindDictionary;
}

- (instancetype)init
{
    return [self initWithDictionary:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)bindDictionary
{
    self = [super init];
    if(self){
        _bindDictionary = bindDictionary == nil ? @{}.mutableCopy : bindDictionary.mutableCopy;
    }
    return self;
}

- (void) bindProtocol : (Protocol *)protocol
      toProviderBlock : (id(^)(id<BTKInjector> injector))getBlock
{
    [self bind:[[BTKInjectorProviderBlockImpl alloc] initWithProtocol:protocol
                                                        getBlock:getBlock]];
}

- (void) bindProvider : (id<BTKInjectorProvider>)provider
{
    if(![provider conformsToProtocol:@protocol(BTKInjectorProvider)]){
        [NSException raise:NSInternalInconsistencyException
                    format:@"Provider Binding %@ does not confirm to protocol %@",
         NSStringFromClass(provider.class),
         NSStringFromProtocol(@protocol(BTKInjectorProvider))];
        return;
    }
    [self bind:provider];
}

- (void) bindFactory : (id<BTKInjectorFactory>)factory
{
    if(![factory conformsToProtocol:@protocol(BTKInjectorFactory)]){
        [NSException raise:NSInternalInconsistencyException
                    format:@"Factory Binding %@ does not confirm to protocol %@",
         NSStringFromClass(factory.class),
         NSStringFromProtocol(@protocol(BTKInjectorFactory))];
        return;
    }
    [self bind:factory];
}

- (void) bind : (id<BTKInjectorBinding>)binding
{
    if(binding.targetProtocol == nil){
        [NSException raise:NSInternalInconsistencyException
                    format:@"Target protocol for binding %@ cannot be nil",
         NSStringFromClass(binding.class)];
        return;
    }
    @synchronized(self){
        NSString *key = NSStringFromProtocol(binding.targetProtocol);
        if([_bindDictionary objectForKey:key]){
            [NSException raise:NSInternalInconsistencyException
                        format:@"Duplicated binding for %@", key];
            return;
        }
        _bindDictionary[key] = binding;
    }
}

- (void) removeBindingForProtocol : (Protocol *)protocol
{
    if(protocol == nil){
        return;
    }
    @synchronized(self){
        [_bindDictionary removeObjectForKey:NSStringFromProtocol(protocol)];
    }
}

#pragma mark BTKInjector

// Mutable injector is used only for building injector.
// So there's no need to tune performance

- (id) instanceForProtocol : (Protocol *)protocol
{
    return [self.copy instanceForProtocol:protocol];
}

- (id)proxyForProtocol:(Protocol *)protocol
{
    return [self.copy proxyForProtocol:protocol];
}

- (id<BTKInjectorProvider>) providerForProtocol : (Protocol *)protocol
{
    return [self.copy providerForProtocol:protocol];
}

- (id<BTKInjectorFactory>) factoryForProtocol : (Protocol *)protocol
{
    return [self.copy factoryForProtocol:protocol];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    @synchronized(self){
        return [[BTKInjectorImpl allocWithZone:zone]initWithDictionary:_bindDictionary];
    }
}

#pragma mark NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone
{
    @synchronized(self){
        return [[self.class allocWithZone:zone]initWithDictionary:_bindDictionary];
    }
}


@end
