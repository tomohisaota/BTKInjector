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

@protocol BTKTestProtocol1 <NSObject>

@property id<BTKTestProtocol2> protocol2;
@property id<BTKTestProtocol3> protocol3;

- (NSString*) test1;

@end

@protocol BTKTestProtocol2 <NSObject>

@property id<BTKTestProtocol1> protocol1;
@property id<BTKTestProtocol3> protocol3;

- (NSString*) test2;

@end

@protocol BTKTestProtocol3 <NSObject>

@property id<BTKTestProtocol1> protocol1;
@property id<BTKTestProtocol2> protocol2;

- (NSString*) test3;

@end

// For Duch Typing Test, same signature as BTKTestProtocol1
@protocol BTKTestProtocol4 <NSObject>

@property id<BTKTestProtocol2> protocol2;
@property id<BTKTestProtocol3> protocol3;

- (NSString*) test1;

@end