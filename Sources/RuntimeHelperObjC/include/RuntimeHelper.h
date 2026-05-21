//
//  RuntimeHelper.h
//  SwiftObjCAdvancedPractice
//
//  Objective-C runtime features demo.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Class that demonstrates method swizzling for logging.
@interface RuntimeHelper : NSObject

/// Swizzles an instance method on a class.
+ (void)swizzleInstanceMethod:(Class)class 
                   originalSelector:(SEL)originalSelector 
                   swizzledSelector:(SEL)swizzledSelector;

/// Creates a dynamic class at runtime.
+ (Class)createDynamicClassWithName:(NSString *)className 
                          superclass:(Class)superclass;

/// Demonstrates KVO (Key-Value Observing).
+ (void)demonstrateKVO;

/// Demonstrates message forwarding.
+ (void)demonstrateMessageForwarding;

/// Demonstrates blocks and GCD.
+ (void)demonstrateBlocksAndGCD;

@end

/// Helper class for the KVO demonstration.
@interface ObservableObject : NSObject
@property (nonatomic, strong) NSString *value;
@end

/// Helper class for the message forwarding demonstration.
@interface MessageForwardingDemo : NSObject
@end

NS_ASSUME_NONNULL_END
