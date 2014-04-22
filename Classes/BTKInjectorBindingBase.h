//
//  BTKInjectorBindingBase.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKInjectorBinding.h"

@interface BTKInjectorBindingBase : NSObject<BTKInjectorBinding>

- (instancetype) initWithProtocol : (Protocol*) targetProtocol;

@end
