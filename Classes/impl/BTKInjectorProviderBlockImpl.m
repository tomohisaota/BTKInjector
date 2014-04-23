//
//  BTKInjectorBinding.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorProviderBlockImpl.h"
#import <libkern/OSAtomic.h>

@implementation BTKInjectorProviderBlockImpl{
    id _obj;
}

- (id)init
{
    return [self initWithProtocol:nil getBlock:nil];
}

- (instancetype) initWithProtocol : (Protocol*) protocol
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
    _getBlock = [getBlock copy];
    return self;
}

- (id)getImpl
{
    return self.getBlock(self.injector);
}

@end
