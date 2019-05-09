//
//  Monkey.m
//  _objc_msgForward_demo
//
//  Created by luguobin on 15/9/21.
//  Copyright © 2015年 XS. All rights reserved.
//

#import "Monkey.h"
#import "ForwardingTarget.h"
#import <objc/runtime.h>

@interface Monkey()
@property (nonatomic, strong) ForwardingTarget *target;
@end

@implementation Monkey

- (instancetype)init
{
    self = [super init];
    if (self) {
        _target = [ForwardingTarget new];
        //将yeyu发送给选择器sel
        [self performSelector:@selector(sel:) withObject:@"哇哈哈"];
    }
    
    return self;
}


id dynamicMethodIMP(id self, SEL _cmd, NSString *str)
{
    NSLog(@"0");
    NSLog(@"%s:动态添加的方法",__FUNCTION__);
    NSLog(@"%@", str);
    return @"1";
}

+ (BOOL)resolveInstanceMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
//    NSLog(@"1");
//    class_addMethod(self.class, sel, (IMP)dynamicMethodIMP, "@@:");
//    BOOL result = [super resolveInstanceMethod:sel];//是否添加好了方法
//    result = YES;
    //1.在没有动态添加方法下，不论返回值为no或者yes，都会进行下一步。
    //2.在动态添加方法下，不论返回yes或者no，都不会走下一步。
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
    NSLog(@"2");
    id result = [super forwardingTargetForSelector:aSelector];
    result = self.target;
    return result; // 2,调用FordingTarget文件中的此函数
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"3");
    id result = [super methodSignatureForSelector:aSelector];
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    result = sig;
    return result; // 3
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    //    [super forwardInvocation:anInvocation];
    anInvocation.selector = @selector(invocationTest);
    [self.target forwardInvocation:anInvocation];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}

@end
