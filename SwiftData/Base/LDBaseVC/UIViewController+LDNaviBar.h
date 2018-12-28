//
//  UIViewController+LDBase.h
//  MainArch_Example
//
//  Created by 令达 on 2018/4/3.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    NaviBarThemeWhite = 0,
    NaviBarThemeBlue
}NaviBarTheme;

@interface UIViewController (LDNaviBar)

/**
 导航条主题颜色
 */
@property (nonatomic,assign) NaviBarTheme ld_theme;

/**
 禁止全屏pop
 */
@property (nonatomic,assign) BOOL ld_forbidFullScreenPop;

/**
 隐藏顶部导航条
 */
@property (nonatomic,assign) BOOL ld_hideNavigationBar;

/**
 设置导航条颜色
 */
@property (nonatomic,strong) UIColor * ld_naviBarColor;

/**
 设置导航条右边的文字，颜色和事件
 */
- (void)ld_setNaviBarRightItemText:(NSString *)text color:(UIColor *)color sel:(SEL)sel;

/**
 设置导航条右边的文字按钮是否可用
 */
- (void)ld_setRightItemEnable:(BOOL)enable;

/**
 设置导航条右边的图片和事件
 */
- (void)ld_setNaviBarRightItemImage:(UIImage *)image render:(BOOL)render sel:(SEL)sel;

@end
