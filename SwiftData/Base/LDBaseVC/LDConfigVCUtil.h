//
//  LDBaseUtil.h
//  MainArch_Example
//
//  Created by 令达 on 2018/3/27.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kVersionKey;
extern NSString * const kLoginStateKey;

@interface LDConfigVCUtil : NSObject

/**
 配置根控制器  参数代表该应用是不是一定要登录才可以进入首页的app

 @param mustLogin 是否必须登录
 */
+ (void)config:(BOOL)mustLogin;

/**
 切换TabC为根控制器
 */
+ (void)configTabCToRootVC;

/**
 切换登录控制器为根控制器，该架构是这样设计的，如果登录控制器成为根控制器，
 那么就一定是必须登录架构
 */
+ (void)configLoginVCToRootVC;


@end


@interface LDNewFeatureView : UIView<UIScrollViewDelegate>

@end


