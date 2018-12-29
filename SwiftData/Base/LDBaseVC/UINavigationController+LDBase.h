//
//  UINavigationController+LDBase.h
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
@interface UINavigationController (LDBase)<UIGestureRecognizerDelegate>
/**
 导航条主题颜色
 */
@property (nonatomic,assign) NaviBarTheme ld_theme;
@end
