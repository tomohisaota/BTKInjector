# BTKInjector

Simple DI(Dependency Injection) Framework designed for Objective C.

# How to install
BTKInjector is available on [Cocoa Pods](http://cocoapods.org)

## Install from Cocoa Pods master

```
pod 'BTKInjector', '~> 1.0.3'
```

## Install from github develop branch

```
pod 'BTKInjector', :git => 'https://github.com/tomohisaota/BTKInjector.git', :branch => "develop"
```


# Basic Concept of Dependency Injection
See [Dependency Injection on Wikipedia](http://en.wikipedia.org/wiki/Dependency_injection)
> Dependency injection is a software design pattern that implements inversion of control and allows a program design to follow the dependency inversion principle. 


## How DI can help me?
Some people say that Objective C is dynamic language and does not need DI. But that is not true at all. DI itself is powerful concept suitable for objective C, and DI container makes DI even better.

One example is Core Data related code. XCode template puts those code in AppDelegate. But does it really have to be there? How do you test the code?

I will walk through the exmaple to show you how DI can help you.

### Define protocol for CoreData
First step is to define protocol. For core data, you typically need 3 properties.

```objc:BTKCoreData.h
@protocol BTKCoreData <NSObject>

@property(strong,readonly,nonatomic) NSManagedObjectModel *managedObjectModel;
@property(strong,readonly,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,readonly,nonatomic) NSManagedObjectContext *managedObjectContext;

@end

```

### Implement CoreData protocol
Implement CoreData protocol in anywhere you want.

```objc:BTKCoreDataImpl.h
#import <Foundation/Foundation.h>
#import "BTKCoreData.h"

@interface BTKCoreDataImpl : NSObject<BTKCoreData>

@end
```

```objc:BTKCoreData.m
#import "BTKCoreDataImpl.h"
#import <CoreData/CoreData.h>

@implementation BTKCoreDataImpl

- (NSManagedObjectModel *)managedObjectModel
{
    // Put your code here
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // Put your code here
}

- (NSManagedObjectContext *)managedObjectContext
{
    // Put your code here
}
```


### Use Core data
Instead of accessing Application Delegate, you can give Core Data instance in intialization.
This is called "Constructor Injection", one of the dependeny injection style.

```objc:BTKYourClass.h
@protocol BTKYourClass <NSObject>

@end
```


```objc:BTKYourClassImpl.h
@interface BTKYourClassImpl : NSObject<BTKYourClass>

@property(strong,readonly,nonatomic) id<BTKCoreData> coreData;

- (id)initWithCoreData : (id<BTKCoreData>) coreData;

@end
```

```objc:BTKYourClassImpl.m
@implement BTKYourClassImpl

- (id)initWithCoreData : (id<BTKCoreData>) coreData
{
    self = [super init];
    if(!self){
        return nil;
    }
    _coreData = coreData;
    return self;
}

@end
```

### Connect those components by DI container
Finally, you need to setup injection as follow

* Return BTKCoreDataImpl instance for BTKCoreData protocol
* Return BTKYourClassImpl instance for BTKYourClass protocol
 *  Inject BTKCoreData in intialization

Here is how you can do it using BTKInjector

```objc:binding
    [BTKGlobalInjector setupGlobalInjector:^(id<BTKMutableInjector> mInjector) {
        [mInjector bindProtocol:@protocol(BTKCoreData)
                toProviderBlock:^id(id<BTKInjector> i) {
                    return [BTKCoreDataImpl new];
                }];
        [mInjector bindProtocol:@protocol(BTKYourClass)
                toProviderBlock:^id(id<BTKInjector> i) {
                    return [[BTKYourClassImpl alloc] initWithCoreData:[i instanceForProtocol:@protocol(BTKCoreData)]];
                }];
    }];
```

Finnaly, you can ask injector to get instance.

```objc:getting
id<BTKYourClass> i = [[BTKGlobalInjector get]instanceForProtocol:@protocol(BTKYourClass)];

```


# BTKInjector
In BTKInjector, you need to write binding for each protocol. binding can be Provider or Factory. Either way, you need to write object creation code for the protocol.

## Factory
BTKInjector will return newly created object for given protocol. 
Your object creation code **get called everytime**.

### Subclass BTKInjectorFactoryBase

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


## Provider
BTKInjector will return same object for given protocol. 
Your object creation code **get called only once**.
In other word, it is singleton per injector.

### Use block
Since method signature for provider is always same, you can write binding using block.
Above Core Data example uses Block based definition.

### Subclass BTKInjectorProviderBase
Just like Factory, you can subclass BTKInjectorProviderBase to write your own provider class.

# Circular dependency
If two components depends on each other in **intialize sequence**, BTKInjector cannot create object. Chicken or egg problem.

Circular dependency after object intialization is totally fine. So inject Provider instead of Instance whereever possible.

# Looking for more powerful framework?
BTKInjector is designed for simplicity.

If you're looking for more powerful DI framework, [Typhoon Framework](http://www.typhoonframework.org) may be the right choice.