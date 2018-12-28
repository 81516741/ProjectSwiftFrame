//
//  UINavigationController+LDBase.m
//  MainArch_Example
//
//  Created by 令达 on 2018/4/3.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "UINavigationController+LDBase.h"
#import <objc/runtime.h>
#import "UIViewController+LDNaviBar.h"

@implementation UINavigationController (LDBase)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(pushViewController:animated:),
            @selector(popViewControllerAnimated:)
        };
        
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"ld_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - hook method
-(void)ld_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self ld_pushViewController:viewController animated:animated];
    
    [self addGesture];
}

-(UIViewController *)ld_popViewControllerAnimated:(BOOL)animated
{
    UIViewController * viewController = [self  ld_popViewControllerAnimated:animated];
    return viewController;
}

#pragma mark - private method
- (void)addGesture
{
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

#pragma mark - delegate gesture
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    //当第一个控制器入栈时忽略
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    //当导航控制器正在转换时禁止
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    //不处理gestureRecognizer相反方向的手势
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    //是否禁止
    if(self.childViewControllers[0].ld_forbidFullScreenPop) {
        return NO;
    }
    
    return YES;
}

@end



