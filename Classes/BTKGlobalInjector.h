//
//  BTKGlobalInjector.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/23.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTKInjector;
@protocol BTKMutableInjector;

@interface BTKGlobalInjector : NSObject

/// Get global injector
+ (id<BTKInjector>) get;

/// Intialize Global Injector, can be called only once
+ (void) setupGlobalInjector : (void(^)(id<BTKMutableInjector> mInjector))initBlock;

/// Remove Global Injector
+ (void) removeGlobalInjector;

/// Create injector. Useful for unit test
+ (id<BTKInjector>) injectorWithBlock : (void(^)(id<BTKMutableInjector> mInjector))initBlock;

@end