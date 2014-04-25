//
//  BTKInjectorBinding.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKInjectorProviderBase.h"

@interface BTKInjectorProviderBlockImpl : BTKInjectorProviderBase

@property(copy,readonly,nonatomic) id (^getBlock)(id<BTKInjector> injector);

- (instancetype) initWithProtocol : (Protocol*) protocol
                     forceConform : (BOOL) forceConform
                         getBlock : (id (^)(id<BTKInjector> injector)) getBlock;

@end
