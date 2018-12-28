//
//  UIViewController+LDLogin.h
//  MainArch
//
//  Created by 令达 on 2018/4/7.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LDLogin)
/**
 这个block是登录成功用的
 */
@property (nonatomic,copy) void(^ld_loginSuccessBlock)(id data);

@end
