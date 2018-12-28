//
//  MBProgressHUD+LDHUD.h
//  Project
//
//  Created by 令达 on 2018/5/3.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (LDHUD)

+ (void)showTipMessageInWindow:(NSString*)message;
+ (void)showTipMessageInView:(UIView *)view message:(NSString *)message;
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)showTipMessageInView:(UIView *)view message:(NSString *)message timer:(NSTimeInterval)aTimer;
+ (void)showTipMessageInView:(UIView *)view message:(NSString*)message  timer:(NSTimeInterval)aTimer dimBackground:(BOOL)dimBackground;


+ (void)showActivityMessageInWindow:(NSString*)message;
+ (void)showActivityMessageInView:(UIView *)view message:(NSString*)message;
+ (void)showActivityMessageInWindow:(NSString*)message timer:(NSTimeInterval)aTimer;
+ (void)showActivityMessageInView:(UIView *)view message:(NSString*)message timer:(NSTimeInterval)aTimer;
+ (void)showActivityMessageInView:(UIView *)view message:(NSString*)message timer:(NSTimeInterval)aTimer dimBackground:(BOOL)dimBackground;


+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message;
+ (void)showInfoMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message;


+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInView:(UIView *)view iconName:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message timer:(NSTimeInterval)aTimer;
+ (void)showCustomIconInView:(UIView *)view iconName:(NSString *)iconName message:(NSString *)message timer:(NSTimeInterval)aTimer;
+ (void)showCustomIconInView:(UIView *)view iconName:(NSString *)iconName message:(NSString *)message timer:(NSTimeInterval)aTimer dimBackground:(BOOL)dimBackground;

+ (void)hideHUDInWindow;
+ (void)hideHUDInView:(UIView *)view;


@end
