//
//  BTKInjectorProviderBase.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//
//  Use volatile object with OSMemoryBarrier to avoid locking
//  Ref : https://www.mikeash.com/pyblog/friday-qa-2009-10-02-care-and-feeding-of-singletons.html

#import "BTKInjectorProviderBase.h"
#import <libkern/OSAtomic.h>

@implementation BTKInjectorProviderBase{
    id volatile _obj;
    BOOL _injecting;
}

- (id)get
{
    // 1st check without synchronized
    if(_obj == nil){
        @synchronized(self){
            // 2nd check with synchronized
            if(_obj == nil){
                if(_injecting){
                    [NSException raise:NSInternalInconsistencyException
                                format:@"Circular reference detected for %@", self.description];
                    return nil;
                }
                _injecting = YES;
                id obj = [self getImpl];
                // Make sure that obj is ready to use
                OSMemoryBarrier();
                _obj = obj;
                _injecting = NO;

                if(![_obj conformsToProtocol:self.targetProtocol]){
                    [NSException raise:NSInternalInconsistencyException
                                format:@"Object from %@ provider does not conforms to its protocol", self.description];
                    
                }
            }
        }
    }
    // Make sure that _obj is ready to use
    OSMemoryBarrier();
    return _obj;
}

- (id)getImpl
{
    // This method is abstract. Should not be called
    [NSException raise:NSInternalInconsistencyException
                format:@"getImpl for %@ should be overridden", self.description];
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ for protocol %@",super.description,NSStringFromProtocol(self.targetProtocol)];
}

@end
