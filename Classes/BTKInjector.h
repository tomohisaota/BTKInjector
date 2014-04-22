//
//  BTKInjector.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>

// Biding Protocols
#import "BTKInjectorBinding.h"
#import "BTKInjectorProvider.h"
#import "BTKInjectorFactory.h"

@protocol BTKInjector <NSObject>

// Syntax sugar. Same as providerForProtocol + get
- (id) instanceForProtocol : (Protocol *)protocol;

- (id) providerForProtocol : (Protocol *)protocol;

- (id) factoryForProtocol : (Protocol *)protocol;

@end


@protocol BTKMutableInjector <BTKInjector>

- (void) bindProtocol : (Protocol *)protocol
      toProviderBlock : (id(^)(id<BTKInjector> injector))getBlock;

- (void) bindProvider : (id<BTKInjectorProvider>)provider;

- (void) bindFactory : (id<BTKInjectorFactory>)factory;

@end


@interface BTKGlobalInjector : NSObject

// Get global injector
+ (id<BTKInjector>) get;

// Intialize Global Injector
+ (void) setupGlobalInjector : (void(^)(id<BTKMutableInjector> mInjector))initBlock;

// Create injector. Useful for unit test
+ (id<BTKInjector>) injectorWithBlock : (void(^)(id<BTKMutableInjector> mInjector))initBlock;

@end