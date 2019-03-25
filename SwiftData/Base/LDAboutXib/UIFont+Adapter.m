//
//  UIFont+Adapter.m
//  RxSwiftStudy
//
//  Created by lingda on 2019/3/11.
//  Copyright © 2019年 lingda. All rights reserved.
//
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
//适配代码设置的字体
CGFloat referenceSize = 375.0;
@implementation UIFont (Adapter)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(systemFontOfSize:),
            @selector(boldSystemFontOfSize:),
            @selector(fontWithName:size:)
        };
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"ld_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            Method originalMethod = class_getClassMethod(self, originalSelector);
            Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (UIFont *)ld_systemFontOfSize:(CGFloat)fontSize {
    CGFloat sizeNew = fontSize * [UIScreen mainScreen].bounds.size.width / referenceSize;
    return [self ld_systemFontOfSize:sizeNew];
}
+ (UIFont *)ld_boldSystemFontOfSize:(CGFloat)fontSize {
    CGFloat sizeNew = fontSize * [UIScreen mainScreen].bounds.size.width / referenceSize;
    return [self ld_boldSystemFontOfSize:sizeNew];
}
+ (UIFont *)ld_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    CGFloat sizeNew = fontSize * [UIScreen mainScreen].bounds.size.width / referenceSize;
    return [self ld_fontWithName:fontName size:sizeNew];
}

@end
