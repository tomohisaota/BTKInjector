//
//  BTKMutableInjectorImpl.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/21.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKInjector.h"

@interface BTKMutableInjectorImpl : NSObject<BTKMutableInjector,NSCopying,NSMutableCopying>

- (instancetype)initWithDictionary : (NSDictionary*) bindDict;

@end
