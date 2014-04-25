//
//  BTKInjectorImpl.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorImpl.h"
#import "BTKMutableInjectorImpl.h"
#import "BTKInjectorProxy.h"

@implementation BTKInjectorImpl{
    NSDictionary *_bindDictionary;
}

- (instancetype)init
{
    return [self initWithDictionary:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)bindDictionary
{
    self = [super init];
    if(self){
        _bindDictionary = bindDictionary == nil ? @{} : bindDictionary.copy;
    }
    // Inject injector
    [_bindDictionary enumerateKeysAndObjectsUsingBlock:^(NSString* key, id<BTKInjectorBinding> binding, BOOL *stop) {
        if(![binding conformsToProtocol:@protocol(BTKInjectorBinding)]){
            [NSException raise:NSInternalInconsistencyException
                        format:@"Binding for %@ does not confirm to protocol %@",
                                    key,
                                    NSStringFromProtocol(@protocol(BTKInjectorBinding))];
        }
        binding.injector = self;
    }];
    return self;
}

- (id) instanceFor : (Protocol *)protocol
{
    return ((id<BTKInjectorProvider>)[self providerFor:protocol]).get;
}

- (id) proxyFor : (Protocol *)protocol;
{
    return [[BTKInjectorProxy alloc] initWithProvider:[self providerFor:protocol]];
}

- (id<BTKInjectorProvider>) providerFor : (Protocol *)protocol
{
    id<BTKInjectorProvider> provider = (id<BTKInjectorProvider>)[self bindingFor:protocol];
    if(![provider conformsToProtocol:@protocol(BTKInjectorProvider)]){
        [NSException raise:NSInternalInconsistencyException
                    format:@"Provider Binding for %@ does not confirm to protocol %@",
                                    NSStringFromProtocol(protocol),
                                    NSStringFromProtocol(@protocol(BTKInjectorProvider))];
        return nil;
    }
    return provider;
}

- (id<BTKInjectorFactory>) factoryFor : (Protocol *)protocol
{
    id<BTKInjectorFactory> factory = (id<BTKInjectorFactory>)[self bindingFor:protocol];
    if(![factory conformsToProtocol:@protocol(BTKInjectorFactory)]){
        [NSException raise:NSInternalInconsistencyException
                    format:@"Factory Binding for %@ does not confirm to protocol %@",
                                    NSStringFromProtocol(protocol),
                                    NSStringFromProtocol(@protocol(BTKInjectorFactory))];
        return nil;
    }
    return factory;
}

- (id<BTKInjectorBinding>) bindingFor : (Protocol *)protocol;
{
    id<BTKInjectorBinding> binding = _bindDictionary[NSStringFromProtocol(protocol)];
    if(binding == nil){
        [NSException raise:NSInternalInconsistencyException
                    format:@"Binding not found for %@", NSStringFromProtocol(protocol)];
        return nil;
    }
    return binding;
}

- (id) instanceForProtocol : (Protocol *)protocol
{
    return [self instanceFor:protocol];
}

- (id) proxyForProtocol : (Protocol *)protocol
{
    return [self proxyFor:protocol];
}

- (id) providerForProtocol : (Protocol *)protocol
{
    return [self providerFor:protocol];
}

- (id) factoryForProtocol : (Protocol *)protocol
{
    return [self factoryFor:protocol];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [[BTKMutableInjectorImpl allocWithZone:zone]initWithDictionary:_bindDictionary];
}

@end
