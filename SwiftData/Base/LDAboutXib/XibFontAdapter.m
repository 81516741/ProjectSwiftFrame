//
//  XibFontAdapter.m
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/3.
//  Copyright © 2018年 lingda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
CGFloat referenceWidth = 375.0;
int ignoreTag = 666;
@implementation UILabel (ld_adjustFont)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(ld_initWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)ld_initWithCoder:(NSCoder*)aDecode{
    [self ld_initWithCoder:aDecode];
    if (self) {
        if(self.tag != ignoreTag){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize * [UIScreen mainScreen].bounds.size.width/referenceWidth];
        }
    }
    return self;
}

@end


@implementation UIButton (ld_adjustFont)
+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(ld_initWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)ld_initWithCoder:(NSCoder*)aDecode{
    [self ld_initWithCoder:aDecode];
    if (self) {
        if(self.tag != ignoreTag){
            CGFloat fontSize = self.titleLabel.font.pointSize;
            self.titleLabel.font = [UIFont systemFontOfSize:fontSize * [UIScreen mainScreen].bounds.size.width/referenceWidth];
        }
    }
    return self;
}

@end

@implementation UITextField (ld_adjustFont)
+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(ld_initWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)ld_initWithCoder:(NSCoder*)aDecode{
    [self ld_initWithCoder:aDecode];
    if (self) {
        if(self.tag != ignoreTag){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize * [UIScreen mainScreen].bounds.size.width/referenceWidth];
        }
    }
    return self;
}
@end

