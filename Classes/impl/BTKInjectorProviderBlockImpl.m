//
//  BTKInjectorBinding.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorProviderBlockImpl.h"
#import "BTKInjectorProxyProtocolOverride.h"

@implementation BTKInjectorProviderBlockImpl{
    id _obj;
    BOOL _forceConform;
    Protocol *_protocol;
}

- (instancetype) initWithProtocol : (Protocol*) protocol
                     forceConform : (BOOL) forceConform
                         getBlock : (id (^)(id<BTKInjector> injector)) getBlock;
{
    self = [super initWithProtocol:protocol];
    if(!self){
        return nil;
    }
    if(getBlock == nil){
        [NSException raise:NSInternalInconsistencyException
                    format:@"getBlock for %@ cannot be nil",NSStringFromClass(self.class)];
        return nil;
    }
    _forceConform = forceConform;
    _getBlock = [getBlock copy];
    _protocol = protocol;
    return self;
}

- (id)getImpl
{
    id obj = self.getBlock(self.injector);
    if(_forceConform){
        obj = [[BTKInjectorProxyProtocolOverride alloc] initWithTarget:obj
                                                              protocol:_protocol];
    }
    return obj;
}

@end
