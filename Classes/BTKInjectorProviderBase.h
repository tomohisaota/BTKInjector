//
//  BTKInjectorProviderBase.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorProvider.h"
#import "BTKInjectorBindingBase.h"

@interface BTKInjectorProviderBase : BTKInjectorBindingBase<BTKInjectorProvider>

/// getImpl get called only once
- (id) getImpl;

@end
