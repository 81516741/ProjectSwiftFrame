//
//  MBProgressHUD+LDHUD.m
//  Project
//
//  Created by 令达 on 2018/5/3.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "MBProgressHUD+LDHUD.h"

@implementation MBProgressHUD (LDHUD)

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message inView:(UIView *)view dimBackground:(BOOL)dimBackground
{
    UIView  * desView = (UIView*)[UIApplication sharedApplication].delegate.window;
    if (view != nil) {
        desView = view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:desView animated:YES];
    hud.detailsLabelText=message?message:@"加载中.....";
    hud.labelFont=[UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = dimBackground;
    return hud;
}

#pragma mark-------------  show Tip --------------
+ (void)showTipMessageInWindow:(NSString*)message
{
    [self showTipMessageInView:nil message:message timer:1.5 dimBackground:NO];
}
+ (void)showTipMessageInView:(UIView *)view message:(NSString *)message
{
    [self showTipMessageInView:view message:message timer:1.5 dimBackground:NO];
}
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer
{
    [self showTipMessageInView:nil message:message timer:aTimer dimBackground:NO];
}
+ (void)showTipMessageInView:(UIView *)view message:(NSString *)message timer:(NSTimeInterval)aTimer
{
    [self showTipMessageInView:view message:message timer:aTimer dimBackground:NO];
}
+ (void)showTipMessageInView:(UIView *)view message:(NSString *)message timer:(NSTimeInterval)aTimer dimBackground:(BOOL)dimBackground
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message inView:view dimBackground:dimBackground];
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:aTimer];
    });
}

#pragma mark----------- show Activity -------------
+ (void)showActivityMessageInWindow:(NSString*)message
{
    [self showActivityMessageInView:nil message:message timer:0 dimBackground:NO];
}
+ (void)showActivityMessageInView:(UIView *)view message:(NSString *)message
{
    [self showActivityMessageInView:view message:message timer:0 dimBackground:NO];
}
+ (void)showActivityMessageInWindow:(NSString*)message timer:(NSTimeInterval)aTimer
{
    [self showActivityMessageInView:nil message:message timer:aTimer dimBackground:NO];
}
+ (void)showActivityMessageInView:(UIView *)view message:(NSString *)message timer:(NSTimeInterval)aTimer
{
    [self showActivityMessageInView:view message:message timer:aTimer dimBackground:NO];
}
+ (void)showActivityMessageInView:(UIView *)view message:(NSString *)message timer:(NSTimeInterval)aTimer dimBackground:(BOOL)dimBackground
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message inView:view dimBackground:dimBackground];
        hud.mode = MBProgressHUDModeIndeterminate;
        if (aTimer>0) {
            [hud hide:YES afterDelay:aTimer];
        }
    });
}

#pragma mark--------  show Image ------------
+ (void)showSuccessMessage:(NSString *)Message
{
    NSString *name =@"MBProgressHUD+LDHUD.bundle/MBProgressHUD/MBHUD_Success";
    [self showCustomIconInWindow:name message:Message];
}
+ (void)showErrorMessage:(NSString *)Message
{
    NSString *name =@"MBProgressHUD+LDHUD.bundle/MBProgressHUD/MBHUD_Error";
    [self showCustomIconInWindow:name message:Message];
}
+ (void)showInfoMessage:(NSString *)Message
{
    NSString *name =@"MBProgressHUD+LDHUD.bundle/MBProgressHUD/MBHUD_Info";
    [self showCustomIconInWindow:name message:Message];
}
+ (void)showWarnMessage:(NSString *)Message
{
    NSString *name =@"MBProgressHUD+LDHUD.bundle/MBProgressHUD/MBHUD_Warn";
    [self showCustomIconInWindow:name message:Message];
}
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message
{
    [self showCustomIconInView:nil iconName:iconName message:message timer:2];
    
}
+ (void)showCustomIconInView:(UIView *)view iconName:(NSString *)iconName message:(NSString *)message
{
    [self showCustomIconInView:view iconName:iconName message:message timer:2];
}

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message timer:(NSTimeInterval)aTimer
{
    [self showCustomIconInView:nil iconName:iconName message:message timer:aTimer dimBackground:NO];
}
+ (void)showCustomIconInView:(UIView *)view iconName:(NSString *)iconName message:(NSString *)message timer:(NSTimeInterval)aTimer
{
    [self showCustomIconInView:view iconName:iconName message:message timer:aTimer dimBackground:NO];
}

+ (void)showCustomIconInView:(UIView *)view iconName:(NSString *)iconName message:(NSString *)message timer:(NSTimeInterval)aTimer dimBackground:(BOOL)dimBackground
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message inView:view dimBackground:dimBackground];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.userInteractionEnabled = NO;
        [hud hide:YES afterDelay:2];
    });
    
}
+ (void)hideHUDInWindow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView  * winView =(UIView*)[UIApplication sharedApplication].delegate.window;
        [self hideAllHUDsForView:winView animated:YES];
    });
}

+ (void)hideHUDInView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
      [self hideAllHUDsForView:view animated:YES];
    });
}

@end
