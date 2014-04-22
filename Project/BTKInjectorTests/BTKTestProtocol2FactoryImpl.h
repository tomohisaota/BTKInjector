//
//  BTKTestProtocol2Factory.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import "BTKInjectorFactoryBase.h"
#import "BTKTestProtocol.h"

@interface BTKTestProtocol2FactoryImpl : BTKInjectorFactoryBase

- (id<BTKTestProtocol2>) protocol2WithString : (NSString*) str;

@end
