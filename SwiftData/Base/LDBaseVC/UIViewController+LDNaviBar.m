//
//  UIViewController+LDBase.m
//  MainArch_Example
//
//  Created by 令达 on 2018/4/3.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "UIViewController+LDNaviBar.h"
#import <objc/runtime.h>
#import "NSObject+LDMonitor.h"
#import "LDLoadBaseSourceUtil.h"
#import "UINavigationController+LDBase.h"



@interface UIViewController (LDBasePrivate)
@property (strong ,nonatomic)UIColor * ld_rightItemColor;
@end

@implementation UIViewController (LDNaviBar)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(viewDidLoad),
            @selector(viewWillAppear:)
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
- (void)ld_viewDidLoad
{
    [self ld_viewDidLoad];
    [self ld_observerDealloc];
}

- (void)ld_viewWillAppear:(BOOL)animated
{
    [self ld_viewWillAppear:animated];
    [self ld_configNavigationBar];
    [self.navigationController setNavigationBarHidden:self.ld_hideNavigationBar animated:animated];
    if (self.ld_naviBarColor) {
        [self ld_setNavibarColor:self.ld_naviBarColor];
    }

}

#pragma mark - public method
-(void)ld_setNavibarColor:(UIColor *)color
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    [self.navigationController.navigationBar setBackgroundImage:[UIViewController ld_imageWithBgColor:color size:CGSizeMake(screenW, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIViewController ld_imageWithBgColor:[UIColor clearColor] size:CGSizeMake(screenW, 1/[UIScreen mainScreen].scale)];
}

- (void)ld_setNaviBarRightItemText:(NSString *)text color:(UIColor *)color sel:(SEL)sel
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:text style:UIBarButtonItemStylePlain target:self action:sel];
    self.navigationItem.rightBarButtonItem.tintColor = color;
    self.ld_rightItemColor = color;
}

- (void)ld_setRightItemEnable:(BOOL)enable
{
    self.navigationItem.rightBarButtonItem.enabled = enable;
    if (enable) {
        self.navigationItem.rightBarButtonItem.tintColor = self.ld_rightItemColor;
    } else{
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
    }
}

- (void)ld_setNaviBarRightItemImage:(UIImage *)image render:(BOOL)render sel:(SEL)sel
{
    if (!render) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:sel];;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
}


#pragma mark - click
- (void)ld_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - private method
- (void)ld_configNavigationBar
{
    UIColor * worldColor;
    NSString * backIconName;
    if (self.ld_theme == NaviBarThemeWhite) {
        worldColor = [UIColor grayColor];
        backIconName = @"icon_back_gray";
        [self ld_setNavibarColor:[UIColor whiteColor]];
    } else if (self.ld_theme == NaviBarThemeBlue) {
        worldColor = [UIColor whiteColor];
        backIconName = @"icon_back_white";
        [self ld_setNavibarColor:[UIColor blueColor]];
    }
    //设置title颜色
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = worldColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    self.navigationItem.titleView = titleLabel;
    
    //添加返回按钮
    if(self.navigationController.childViewControllers.count > 1){
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(ld_back) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0, 0, 58, 44);
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.image =
        [[LDLoadBaseSourceUtil getImage:backIconName]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        imageView.frame = CGRectMake(0, 10, 10, 20);
        
        UILabel * wordLable = [[UILabel alloc] initWithFrame:CGRectMake(15, -2, 40, 44)];
        wordLable.font = [UIFont systemFontOfSize:15];
        wordLable.textColor = worldColor;
        wordLable.text = @"返回";
        
        UIView * customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 44)];
        [customView addSubview:backButton];
        [customView addSubview:imageView];
        [customView addSubview:wordLable];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
}


- (void)ld_observerDealloc
{
    NSString * VCName = NSStringFromClass(self.class);
    self.deallocBlock = ^{
        NSLog(@"\n控制器 (%@) ------- 被销毁",VCName);
    };
}

+(UIImage *)ld_imageWithBgColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - set get
- (void)setLd_rightItemColor:(UIColor *)ld_rightItemColor
{
    objc_setAssociatedObject(self, @selector(ld_rightItemColor), ld_rightItemColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)ld_rightItemColor
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setLd_forbidFullScreenPop:(BOOL)ld_forbidFullScreenPop
{
    objc_setAssociatedObject(self, @selector(ld_forbidFullScreenPop), @(ld_forbidFullScreenPop), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)ld_forbidFullScreenPop
{
    BOOL boolValue = [objc_getAssociatedObject(self, _cmd) boolValue];
    return boolValue;
}

- (void)setLd_hideNavigationBar:(BOOL)ld_hideNavigationBar
{
    objc_setAssociatedObject(self, @selector(ld_hideNavigationBar), @(ld_hideNavigationBar), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)ld_hideNavigationBar
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (UIColor *)ld_naviBarColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLd_naviBarColor:(UIColor *)ld_naviBarColor
{
    objc_setAssociatedObject(self, @selector(ld_naviBarColor), ld_naviBarColor, OBJC_ASSOCIATION_RETAIN);
}

- (void)setLd_theme:(NaviBarTheme)ld_theme
{
    objc_setAssociatedObject(self, @selector(ld_theme), @(ld_theme), OBJC_ASSOCIATION_ASSIGN);
}

- (NaviBarTheme)ld_theme
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
@end
