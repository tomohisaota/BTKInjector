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
- (id) instanceForProtocol : (Protocol *)protocol;

/// Get provider for given protocol. calling provider returns singleton instance
- (id) providerForProtocol : (Protocol *)protocol;

/// Get factory for given protocol. calling factory create new instance
- (id) factoryForProtocol : (Protocol *)protocol;

@end

// Import other headers
#import "BTKGlobalInjector.h"
#import "BTKMutableInjector.h"

#import "BTKInjectorProvider.h"
#import "BTKInjectorProviderBase.h"

#import "BTKInjectorFactory.h"
#import "BTKInjectorFactoryBase.h"
