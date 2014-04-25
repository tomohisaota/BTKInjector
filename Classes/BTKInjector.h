//
//  BTKInjector.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTKInjector <NSObject>

- (id) proxyFor : (Protocol *)protocol;

@end

// Import other headers
#import "BTKGlobalInjector.h"
#import "BTKMutableInjector.h"