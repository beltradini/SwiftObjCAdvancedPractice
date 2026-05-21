//
//  RuntimeHelper.m
//  SwiftObjCAdvancedPractice
//
//  Objective-C runtime features implementation.
//

#import "include/RuntimeHelper.h"
#import <objc/runtime.h>

static id customDescriptionIMP(id self, SEL _cmd);

// MARK: - Method Swizzling Implementation

@implementation RuntimeHelper

/// Swizzles an instance method for a class.
+ (void)swizzleInstanceMethod:(Class)class 
                   originalSelector:(SEL)originalSelector 
                   swizzledSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                           swizzledSelector,
                           method_getImplementation(originalMethod),
                           method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    NSLog(@"[RuntimeHelper] Swizzled %@ with %@", 
          NSStringFromSelector(originalSelector), 
          NSStringFromSelector(swizzledSelector));
}

/// Creates a dynamic class at runtime.
+ (Class)createDynamicClassWithName:(NSString *)className 
                          superclass:(Class)superclass {
    
    // Allocate the class pair.
    Class newClass = objc_allocateClassPair(superclass, 
                                           [className UTF8String], 
                                           0);
    
    if (!newClass) {
        NSLog(@"[RuntimeHelper] Failed to allocate class %@", className);
        return nil;
    }
    
    // Add a new instance variable.
    class_addIvar(newClass, 
                  "dynamicProperty", 
                  sizeof(NSString *), 
                  0, 
                  "@");
    
    // Add a new method.
    Method originalMethod = class_getInstanceMethod(superclass, @selector(description));
    const char *types = method_getTypeEncoding(originalMethod);
    class_addMethod(newClass, 
                   @selector(customDescription), 
                   (IMP)customDescriptionIMP, 
                   types);
    
    // Register the class.
    objc_registerClassPair(newClass);
    
    NSLog(@"[RuntimeHelper] Created dynamic class %@", className);
    
    return newClass;
}

// Custom method implementation for the dynamic class.
static id customDescriptionIMP(id self, SEL _cmd) {
    return [NSString stringWithFormat:@"<DynamicClass: %p - Custom Description>", self];
}

/// Demonstrates KVO (Key-Value Observing).
+ (void)demonstrateKVO {
    NSLog(@"[RuntimeHelper] --- KVO Demonstration ---");
    
    // Create a simple observable object.
    ObservableObject *obj = [[ObservableObject alloc] init];
    obj.value = @"Initial Value";
    
    // Add observer and use the class object as the observer.
    [obj addObserver:(NSObject *)self 
          forKeyPath:@"value" 
             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 
             context:nil];
    
    // Change the value.
    obj.value = @"New Value";
    
    // Remove observer.
    [obj removeObserver:(NSObject *)self forKeyPath:@"value"];
    
    NSLog(@"[RuntimeHelper] --- KVO Demonstration Complete ---");
}

+ (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change 
                       context:(void *)context {
    NSLog(@"[RuntimeHelper] KVO: %@ changed from %@ to %@", 
          keyPath, 
          change[NSKeyValueChangeOldKey], 
          change[NSKeyValueChangeNewKey]);
}

/// Demonstrates message forwarding.
+ (void)demonstrateMessageForwarding {
    NSLog(@"[RuntimeHelper] --- Message Forwarding Demonstration ---");
    
    MessageForwardingDemo *demo = [[MessageForwardingDemo alloc] init];
    
    // This method does not exist, so it triggers message forwarding.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [demo performSelector:@selector(undefinedMethod:) withObject:@"Hello"];
#pragma clang diagnostic pop
    
    NSLog(@"[RuntimeHelper] --- Message Forwarding Demonstration Complete ---");
}

/// Demonstrates blocks and GCD.

+ (void)demonstrateBlocksAndGCD {
    NSLog(@"[RuntimeHelper] --- Blocks and GCD Demonstration ---");
    
    // Serial queue.
    dispatch_queue_t serialQueue = dispatch_queue_create("com.example.serial", DISPATCH_QUEUE_SERIAL);
    
    // Concurrent queue.
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Dispatch group.
    dispatch_group_t group = dispatch_group_create();
    
    NSLog(@"[RuntimeHelper] Starting concurrent tasks");
    
    // Task 1.
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"[RuntimeHelper] Task 1 started");
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"[RuntimeHelper] Task 1 completed");
    });
    
    // Task 2.
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"[RuntimeHelper] Task 2 started");
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"[RuntimeHelper] Task 2 completed");
    });
    
    // Task 3.
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"[RuntimeHelper] Task 3 started");
        [NSThread sleepForTimeInterval:0.3];
        NSLog(@"[RuntimeHelper] Task 3 completed");
    });
    
    // Notify when all tasks complete.
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"[RuntimeHelper] All tasks completed");
        
        // Demonstrate a block with capture.
        NSString *capturedValue = @"Captured";
        void (^completionBlock)(void) = ^{
            NSLog(@"[RuntimeHelper] Block executed with value: %@", capturedValue);
        };
        completionBlock();
    });
    
    // Semaphore example.
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"[RuntimeHelper] Semaphore task started");
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"[RuntimeHelper] Semaphore task completed");
        dispatch_semaphore_signal(semaphore);
    });
    
    // Wait for semaphore.
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"[RuntimeHelper] Semaphore wait completed");
    
    NSLog(@"[RuntimeHelper] --- Blocks and GCD Demonstration Complete ---");
}

@end

// MARK: - Helper Classes

@implementation ObservableObject {
    NSString *_value;
}

- (NSString *)value {
    return _value;
}

- (void)setValue:(NSString *)value {
    _value = [value copy];
}

@end

@implementation MessageForwardingDemo

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSLog(@"[MessageForwardingDemo] methodSignatureForSelector: %@", NSStringFromSelector(sel));
    
    // Return a signature for unknown selectors
    if (sel == @selector(undefinedMethod:)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    
    return [super methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSLog(@"[MessageForwardingDemo] forwardInvocation: %@", NSStringFromSelector([invocation selector]));
    
    SEL selector = [invocation selector];
    
    if (selector == @selector(undefinedMethod:)) {
        NSString *arg;
        [invocation getArgument:&arg atIndex:2];
        NSLog(@"[MessageForwardingDemo] Handled undefined method with arg: %@", arg);
    } else {
        [super forwardInvocation:invocation];
    }
}

- (void)doesNotRecognizeSelector:(SEL)sel {
    NSLog(@"[MessageForwardingDemo] doesNotRecognizeSelector: %@", NSStringFromSelector(sel));
    [super doesNotRecognizeSelector:sel];
}

@end
