# BTKInjector

BTKInjector is Dependency Injection Framework for Objective C. It supports Singleton Provider and Factory binding by protocol. 

Binding

```objc:BTKMutableInjector.h
@protocol BTKMutableInjector <BTKInjector>
- (void) bindProtocol : (Protocol *)protocol
      toProviderBlock : (id(^)(id<BTKInjector> injector))getBlock;
- (void) bindProvider : (id<BTKInjectorProvider>)provider;
- (void) bindFactory : (id<BTKInjectorFactory>)factory;
- (void) removeBindingForProtocol : (Protocol *)protocol;
@end
```

Injecting

```objc:BTKInjector.h
@protocol BTKInjector <NSObject>
- (id) instanceForProtocol : (Protocol *)protocol;
- (id) proxyForProtocol : (Protocol *)protocol;
- (id) providerForProtocol : (Protocol *)protocol;
- (id) factoryForProtocol : (Protocol *)protocol;
@end
```

## How to install
BTKInjector is available on [Cocoa Pods](http://cocoapods.org)


```
pod 'BTKInjector', '~> 1.0.3'
```
or you can use latest code from github

```
pod 'BTKInjector', :git => 'https://github.com/tomohisaota/BTKInjector.git', :branch => "develop"
```

## Bind Provider to protocol
BTKInjector will return same object for given protocol. 
Your object creation code **get called only once**.

### By provider block


```objc
    [BTKGlobalInjector setupGlobalInjector:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKTestProtocol1)
                toProviderBlock:^id(id<BTKInjector> i) {
                    BTKTestProtocol1Impl *o = [BTKTestProtocol1Impl new];
                    o.protocol2Provider = [i providerForProtocol:@protocol(BTKTestProtocol2)];
                    return o;
                }];
    }];
```

### Inject provider
Inject BTKInjectorProvider, and you can get target instance by calling "get".

### Inject instance
Syntax sugar. Equivalent to provider injection + "get".

### Inject proxy
Return proxy object which has reference to provider. It acts just like instance injection, but does not call provider.get until necessary.

## Bind Factory to protocol
BTKInjector will return newly created object for given protocol. 
Your object creation code **get called everytime**.


Define protocol for Factory.

```objc
@protocol BTKSampleFactory <NSObject>

- (id<BTKSample>) sampleWithString : (NSString*) str;

@end
```

Subclass BTKInjectorFactoryBase, and implement your factory protocol.

```objc
@interface BTKSampleFactoryImpl : BTKInjectorFactoryBase<BTKSampleFactory>

@end

```

self.injector get injected automatically.
You can use the injector to get provider,facotory or instance for any protocol.

```objc
@implementation BTKSampleFactoryFactoryImpl

- (id)init
{
    return [super initWithProtocol:@protocol(BTKSample)];
}

- (id<BTKSample>) sampleWithString : (NSString*) str
{
    return [[BTKSample alloc]initWithString:str
                                    otherObj:[self.injector instanceForProtocol:@protocol(OtherProtocol)];
}

@end
```

Register binding to injector.

```objc
[mInjector bindFactory:[BTKSampleFactoryFactoryImpl new]];
```

### Inject factory by protocol




## Circular dependency
If two components depends on each other in **intialize sequence**, BTKInjector cannot create object. Chicken or egg problem.

Circular dependency after object intialization is totally fine. So inject Proxy or Provider instead of Instance whereever possible.

## License
BTKInjector is created and maintained by Tomohisa Ota under the Apache 2.0 license.