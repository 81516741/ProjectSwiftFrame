//
//  LDBaseUtil.m
//  MainArch_Example
//
//  Created by 令达 on 2018/3/27.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "LDConfigVCUtil.h"
#import "LDLoadBaseSourceUtil.h"
#import "UITabBarController+LDBase.h"
#import "UIViewController+LDLogin.h"
#import "SwiftData-Swift.h"

NSString * const kVersionKey = @"CFBundleShortVersionString";
NSString * const kLoginStateKey = @"kLoginStateKey";

#pragma mark - LDConfigVCUtil
@implementation LDConfigVCUtil

+ (void)config:(BOOL)mustLogin
{
    //打印cachepath，因为这个会经常使用到
    NSString * cachePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",cachePath);
    //创建window
    UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].delegate.window = window;
    [window makeKeyAndVisible];
    
    if (mustLogin) {
        BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:kLoginStateKey] boolValue];
        if (isLogin) {//代表登录了
            [LDConfigVCUtil configTabCToRootVC];
        }else {
            [LDConfigVCUtil configLoginVCToRootVC];
        }
    } else {
        [LDConfigVCUtil configTabCToRootVC];
    }
    
}

+ (void)configLoginVCToRootVC
{
    UINavigationController * loginVCNavi = [[Mediator sharedInstance] login_getLoginController];
    if (loginVCNavi != nil) {
        //是否需要展示新特性
        if ([self isShowIntroductionVC]) {
            LDNewFeatureView * view = [[LDNewFeatureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [loginVCNavi.view addSubview:view];
        }
        [UIApplication sharedApplication].delegate.window.rootViewController = loginVCNavi;
    }
    
}

+ (void)configTabCToRootVC
{
    NSMutableArray * vcs = [NSMutableArray arrayWithCapacity:5];
    //模块A
    UIViewController * vcANavi = [[Mediator sharedInstance] home_getHomeController];
    if(vcANavi != nil) {
        [vcs addObject:vcANavi];
    }
    
    //模块B
    UINavigationController * vcBNavi = [[Mediator sharedInstance] me_getMeController];
    if(vcBNavi != nil) {
        [vcs addObject:vcBNavi];
    }
    
    //添加各个模块到TabVC
    UITabBarController * tabbarc = [UITabBarController tabVC:vcs];
    
    //是否需要展示新特性
    if ([self isShowIntroductionVC]) {
        LDNewFeatureView * view = [[LDNewFeatureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [tabbarc.view addSubview:view];
    }
    [UIApplication sharedApplication].delegate.window.rootViewController = tabbarc;
}


#pragma mark - private method  LDConfigVCUtil
+(BOOL)isShowIntroductionVC
{
    if ([[self currentVersion] isEqualToString:[self localVersion]]) {
        return NO;
    }else{
        return YES;
    }
}

+(NSString *)currentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuild = [infoDictionary objectForKey:kVersionKey];
    appBuild = appBuild !=nil ? appBuild: @"";
    return appBuild;
}

+(NSString *)localVersion
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kVersionKey];
}

+(void)updateLocalVersion
{
    [[NSUserDefaults standardUserDefaults]setObject:[self currentVersion] forKey:kVersionKey];
}

@end


#pragma mark - LDNewFeatureView
@implementation LDNewFeatureView

NSArray * images;
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

#pragma mark - delegate scrollView LDNewFeatureView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    if (scrollView.contentOffset.x > ((images.count - 1) * [UIScreen mainScreen].bounds.size.width + [UIScreen mainScreen].bounds.size.width * 0.25)) {
        [self remove];
    }
}

#pragma mark - click  LDNewFeatureView
- (void)btnClick
{
    [self remove];
}

#pragma mark - private method  LDNewFeatureView
- (void)configView
{
    images = @[@"P1",@"P2",@"P3",@"P4"];
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview: scrollView];
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * images.count, 0);
    
    for (int i = 0; i < images.count; i ++) {
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[LDLoadBaseSourceUtil getImage:images[i]]];
        imageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [scrollView addSubview:imageView];
        if (i == images.count - 1) {
            imageView.userInteractionEnabled = YES;
            CGFloat width = 200;
            CGFloat height = 50;
            UIImageView * clickImageView = [[UIImageView alloc]initWithImage:[LDLoadBaseSourceUtil getImage:@"BTN_entre"]];
            clickImageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - width) * 0.5, [UIScreen mainScreen].bounds.size.height - height - 40, width, height);
            [imageView addSubview:clickImageView];
            clickImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
            [clickImageView addGestureRecognizer:tapGes];
        }
        
    }
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)remove
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [LDConfigVCUtil updateLocalVersion];
}

@end
