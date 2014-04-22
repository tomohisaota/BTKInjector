//
//  BTKInjectorBinding.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTKInjector;

@protocol BTKInjectorBinding <NSObject>

@property(assign,readonly,nonatomic) Protocol *targetProtocol;
@property(strong,readwrite,nonatomic) id<BTKInjector> injector;

@end
