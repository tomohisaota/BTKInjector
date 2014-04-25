//
//  BTKInjectorDuckProxy.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/25.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTKInjectorProxyProtocolOverride : NSProxy

- (instancetype) initWithTarget : (id) target
                       protocol : (Protocol*)protocol;

@end
