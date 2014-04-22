//
//  BTKInjectorGlobal.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjector.h"
#import "BTKMutableInjectorImpl.h"

static id<BTKInjector> globalInjector;

@implementation BTKGlobalInjector

+ (id<BTKInjector>) get
{
    @synchronized(self){
        if(globalInjector == nil){
            [NSException raise:NSInternalInconsistencyException
                        format:@"Global Injector is not set"];
            return nil;
        }
        return globalInjector;
    }
}

+ (void) setupGlobalInjector : (void(^)(id<BTKMutableInjector> mInjector))initBlock
{
    NSLog(@"Setting Global Injector");
    @synchronized(self){
        if(globalInjector != nil){
            [NSException raise:NSInternalInconsistencyException
                        format:@"Global injector is already set"];
            return;
        }
        globalInjector = [self injectorWithBlock:initBlock];
    }
}

+ (void) removeGlobalInjector
{
    @synchronized(self){
        globalInjector = nil;
    }
}

+ (id<BTKInjector>) injectorWithBlock : (void(^)(id<BTKMutableInjector> mInjector))initBlock
{
    if(initBlock == nil){
        [NSException raise:NSInternalInconsistencyException
                    format:@"initBlock cannot be nil"];
        return nil;
    }
    BTKMutableInjectorImpl *mInjector = [BTKMutableInjectorImpl new];
    initBlock(mInjector);
    return mInjector.copy;
}

@end
