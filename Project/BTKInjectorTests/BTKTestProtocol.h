//
//  BTKTestProtocol.h
//  BTKInjector
//
//  Created by Tomohisa Ota on 2014/04/22.
//  Copyright (c) 2014 Tomohisa Ota. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTKTestProtocol1;
@protocol BTKTestProtocol2;
@protocol BTKTestProtocol3;
@protocol BTKTestProtocol1Provider;
@protocol BTKTestProtocol2Provider;
@protocol BTKTestProtocol3Provider;

@protocol BTKTestProtocol1 <NSObject>

@property id<BTKTestProtocol2> protocol2;
@property id<BTKTestProtocol2Provider> protocol2Provider;

@property id<BTKTestProtocol3> protocol3;
@property id<BTKTestProtocol3Provider> protocol3Provider;

- (NSString*) test1;

@end

@protocol BTKTestProtocol2 <NSObject>

@property id<BTKTestProtocol1> protocol1;
@property id<BTKTestProtocol1Provider> protocol1Provider;

@property id<BTKTestProtocol3> protocol3;
@property id<BTKTestProtocol3Provider> protocol3Provider;

- (NSString*) test2;

@end

@protocol BTKTestProtocol3 <NSObject>

@property id<BTKTestProtocol1> protocol1;
@property id<BTKTestProtocol1Provider> protocol1Provider;

@property id<BTKTestProtocol2> protocol2;
@property id<BTKTestProtocol2Provider> protocol2Provider;

- (NSString*) test3;

@end

@protocol BTKTestProtocol1Provider <NSObject>

- (id<BTKTestProtocol1>)get;

@end

@protocol BTKTestProtocol2Provider <NSObject>

- (id<BTKTestProtocol2>)get;

@end

@protocol BTKTestProtocol3Provider <NSObject>

- (id<BTKTestProtocol3>)get;

@end


@protocol BTKTestProtocol2Factory <NSObject>

- (id<BTKTestProtocol2>) protocol2WithString : (NSString*) str;

@end
