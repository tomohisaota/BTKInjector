# BTKInjector

BTKInjector is Dependency Injection Framework for Objective C. It is designed to do one thing well. **Injecting singleton instance with dependencies.**

## What is unique about BTKInjector?
If you're familir with DI, you may think that DI container will create object, and inject dependencies. BTKInjector does not do either of them. Instead, BTKInjector helps you create object with dependencies.

## Proxy -> Provider -> Instance
Let's say you have Protocol1 and Protocol2 depending each other. You can write provider block as follow.

```objc:Example
 [mInjector bindProtocol:@protocol(Protocol1)
                toProviderBlock:^id(id<BTKInjector> i) {
                    Protocol1Impl *o = [Protocol1Impl new];
                    o.protocol2 = [i proxyFor:@protocol(Protocol2)];
                    return o;
                }];
 [mInjector bindProtocol:@protocol(Protocol2)
                toProviderBlock:^id(id<BTKInjector> i) {
                    Protocol2Impl *o = [Protocol2Impl new];
                    o.protocol1 = [i proxyFor:@protocol(Protocol1)];
                    return o;
                }];
```
It is hard to build those object because of chicken or egg problem. But BTKInjector solve the problem by injecting lazy loading proxy object. Injected proxy does not load dependency until necessary, but acts just like instance.

Injector and Proxy is carefully designed to support **multi-threading environment without any lock.**

## Interfaces
Protocol defintion is self-explaining.

```objc:BTKInjector.h
@protocol BTKInjector <NSObject>

- (id) proxyFor : (Protocol *)protocol;

@end
```

```objc:BTKMutableInjector.
@protocol BTKMutableInjector <BTKInjector>

- (void) bindProtocol : (Protocol *)protocol
      toProviderBlock : (id(^)(id<BTKInjector> injector))getBlock;

- (void) bindProtocol : (Protocol *)protocol
         forceConform : (BOOL) forceConform
      toProviderBlock : (id(^)(id<BTKInjector> injector))getBlock;

@end
```

```objc:BTKGlobalInjector.h
@interface BTKGlobalInjector : NSObject

+ (id<BTKInjector>) get;

+ (void) setupGlobalInjector : (void(^)(id<BTKMutableInjector> mInjector))initBlock;

+ (void) removeGlobalInjector;

+ (id<BTKInjector>) injectorWithBlock : (void(^)(id<BTKMutableInjector> mInjector))initBlock;

@end
```

## Global injector
Just like other DI container, you can setup global injector as entry point.

```objc
    [BTKGlobalInjector setupGlobalInjector:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKTestProtocol1)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol1Impl *o = [BTKTestProtocol1Impl new];
                    o.protocol2Provider = [i proxyFor:@protocol(BTKTestProtocol2)];
                    return o;
                }];
    }];
```

## Factory
Factory is just a singleton instace to create new instances. You can inject the injector so that factory instance can load any dependency.

## How to install
BTKInjector is available on [Cocoa Pods](http://cocoapods.org)

```
pod 'BTKInjector', '~> 2.0.0'
```
or you can use latest code from github

```
pod 'BTKInjector', :git => 'https://github.com/tomohisaota/BTKInjector.git', :branch => "develop"
```

## License
BTKInjector is created and maintained by Tomohisa Ota under the Apache 2.0 license.