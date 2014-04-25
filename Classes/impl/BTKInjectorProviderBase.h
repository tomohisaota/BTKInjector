//
//  BTKInjectorProviderBase.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKInjector.h"

@interface BTKInjectorProviderBase : NSObject

@property(assign,readonly,nonatomic) Protocol *targetProtocol;
@property(strong,readwrite,nonatomic) id<BTKInjector> injector;

- (instancetype) initWithProtocol : (Protocol*) targetProtocol;

- (id) get;

/// getImpl get called only once
- (id) getImpl;

@end
