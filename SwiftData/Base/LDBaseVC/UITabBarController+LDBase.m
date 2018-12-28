//
//  UITabBarController+LDBase.m
//  MainArch_Example
//
//  Created by 令达 on 2018/4/3.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "UITabBarController+LDBase.h"

@implementation UITabBarController (LDBase)
+(instancetype)tabVC:(NSArray<UIViewController *> *)vcs
{
    UITabBarController * tabC = [[UITabBarController alloc]init];
    tabC.delegate = tabC;
    for (UIViewController * vc in vcs) {
        [tabC addChildViewController:vc];
    }
    return tabC;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%lu",(unsigned long)tabBarController.selectedIndex);
}
@end
