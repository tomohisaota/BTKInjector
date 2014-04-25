//
//  BTKMutableInjector.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/23.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTKInjector;
@protocol BTKInjectorProvider;
@protocol BTKInjectorFactory;

@protocol BTKMutableInjector <BTKInjector>

- (void) bindProtocol : (Protocol *)protocol
      toProviderBlock : (id(^)(id<BTKInjector> injector))getBlock;

- (void) bindProtocol : (Protocol *)protocol
         forceConform : (BOOL) forceConform
      toProviderBlock : (id(^)(id<BTKInjector> injector))getBlock;

- (void) bindProvider : (id<BTKInjectorProvider>)provider;

- (void) bindFactory : (id<BTKInjectorFactory>)factory;

- (void) removeBindingForProtocol : (Protocol *)protocol;

@end