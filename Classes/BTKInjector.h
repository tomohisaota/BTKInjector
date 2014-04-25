//
//  BTKInjector.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTKInjector <NSObject>

/// Get instance for given protocol. syntax sugar for provider + get
- (id) instanceFor : (Protocol *)protocol;

/// Get proxy for given protocol. proxy object calls provider when needed
- (id) proxyFor : (Protocol *)protocol;

/// Get provider for given protocol. calling provider returns singleton instance
- (id) providerFor : (Protocol *)protocol;

/// Get factory for given protocol. calling factory create new instance
- (id) factoryFor : (Protocol *)protocol;


- (id) instanceForProtocol : (Protocol *)protocol __deprecated_msg("use instanceFor instead.");
- (id) proxyForProtocol : (Protocol *)protocol __deprecated_msg("use proxyFor instead.");
- (id) providerForProtocol : (Protocol *)protocol __deprecated_msg("use providerFor instead.");
- (id) factoryForProtocol : (Protocol *)protocol __deprecated_msg("use factoryFor instead.");

@end

// Import other headers
#import "BTKGlobalInjector.h"
#import "BTKMutableInjector.h"

#import "BTKInjectorProvider.h"
#import "BTKInjectorProviderBase.h"

#import "BTKInjectorFactory.h"
#import "BTKInjectorFactoryBase.h"
