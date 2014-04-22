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
        return globalInjector;
    }
}

+ (void) setupGlobalInjector : (void(^)(id<BTKMutableInjector> mInjector))initBlock
{
    @synchronized(self){
        globalInjector = [self injectorWithBlock:initBlock];
    }
}

+ (id<BTKInjector>) injectorWithBlock : (void(^)(id<BTKMutableInjector> mInjector))initBlock
{
    if(initBlock == nil){

        return nil;
    }
    BTKMutableInjectorImpl *mInjector = [BTKMutableInjectorImpl new];
    initBlock(mInjector);
    return mInjector.copy;
}

@end
