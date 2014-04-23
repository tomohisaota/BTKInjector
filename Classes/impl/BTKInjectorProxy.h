//
//  BTKInjectorProxy.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/23.
//  Copyright (c) 2014年 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKInjectorProvider.h"

@interface BTKInjectorProxy : NSObject

- (instancetype) initWithProvider : (id<BTKInjectorProvider>) provider;

@end