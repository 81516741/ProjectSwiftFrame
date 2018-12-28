//
//  UIViewController+LDLogin.m
//  MainArch
//
//  Created by 令达 on 2018/4/7.
//

#import "UIViewController+LDLogin.h"
#import <objc/runtime.h>

@implementation UIViewController (LDLogin)
- (void)setLd_loginSuccessBlock:(void (^)(id))ld_loginSuccessBlock
{
    objc_setAssociatedObject(self, @selector(ld_loginSuccessBlock), ld_loginSuccessBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(id))ld_loginSuccessBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLd_loginCompleteBlock:(dispatch_block_t)ld_loginCompleteBlock
{
    objc_setAssociatedObject(self, @selector(ld_loginCompleteBlock), ld_loginCompleteBlock, OBJC_ASSOCIATION_COPY);
}

- (dispatch_block_t)ld_loginCompleteBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
