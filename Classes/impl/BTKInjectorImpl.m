//
//  BTKInjectorImpl.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorImpl.h"
#import "BTKMutableInjectorImpl.h"
#import "BTKInjectorProxyLazy.h"

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
    [_bindDictionary enumerateKeysAndObjectsUsingBlock:^(NSString* key, BTKInjectorProviderBase* binding, BOOL *stop) {
        binding.injector = self;
    }];
    return self;
}

- (id) proxyFor : (Protocol *)protocol
{
    BTKInjectorProviderBase* provider = _bindDictionary[NSStringFromProtocol(protocol)];
    return [[BTKInjectorProxyLazy alloc] initWithProvider:provider];
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
