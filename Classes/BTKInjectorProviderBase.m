//
//  BTKInjectorProviderBase.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorProviderBase.h"

@implementation BTKInjectorProviderBase{
    id _obj;
    BOOL _injecting;
}

- (id)get
{
    // TODO: consider lock free implementation
    // Maybe using OSAtomicCompareAndSwapPtrBarrier, but Is it worth doing?
    @synchronized(self){
        if(_obj == nil){
            if(_injecting){
                [NSException raise:NSInternalInconsistencyException
                            format:@"Circular reference detected for %@", self.description];
                return nil;
            }
            _injecting = YES;
            _obj = [self getImpl];
            _injecting = NO;
            if(![_obj conformsToProtocol:self.targetProtocol]){
                [NSException raise:NSInternalInconsistencyException
                            format:@"Object from %@ provider does not confirm to its protocol", self.description];
                
            }
        }
        return _obj;
    }
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
