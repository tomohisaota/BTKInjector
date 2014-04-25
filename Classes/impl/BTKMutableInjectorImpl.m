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
    [self bindProtocol:protocol
          forceConform:NO
       toProviderBlock:getBlock];
}

- (void) bindProtocol : (Protocol *)protocol
         forceConform : (BOOL) forceConform
      toProviderBlock : (id(^)(id<BTKInjector> injector))getBlock
{
    if(protocol == nil){
        [NSException raise:NSInternalInconsistencyException
                    format:@"Target protocol cannot be nil"];
        return;
    }
    @synchronized(self){
        NSString *key = NSStringFromProtocol(protocol);
        if([_bindDictionary objectForKey:key]){
            [NSException raise:NSInternalInconsistencyException
                        format:@"Duplicated binding for %@", key];
            return;
        }
        _bindDictionary[key] = [[BTKInjectorProviderBlockImpl alloc] initWithProtocol : protocol
                                                                         forceConform : forceConform
                                                                             getBlock : getBlock];
    }
}

#pragma mark BTKInjector

// Mutable injector is used only for building injector.
// So there's no need to tune performance

- (id) proxyFor : (Protocol *)protocol
{
    return [self.copy proxyFor:protocol];
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
