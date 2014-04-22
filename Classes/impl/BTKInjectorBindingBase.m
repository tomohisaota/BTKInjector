//
//  BTKInjectorBindingBase.m
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorBindingBase.h"

@implementation BTKInjectorBindingBase

@synthesize targetProtocol = _targetProtocol;
@synthesize injector = _injector;

- (instancetype) initWithProtocol : (Protocol*) targetProtocol
{
    self = [super init];
    if(!self){
        return nil;
    }
    _targetProtocol = targetProtocol;
    return self;
}

@end
