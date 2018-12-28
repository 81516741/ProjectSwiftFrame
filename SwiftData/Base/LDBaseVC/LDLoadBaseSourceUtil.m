//
//  LDLoadSourceUtil.m
//  CocoaLumberjack
//
//  Created by 令达 on 2018/4/4.
//

#import "LDLoadBaseSourceUtil.h"

@implementation LDLoadBaseSourceUtil

+ (UIImage *)getImage:(NSString *)imageName
{
    return [UIImage imageNamed:imageName];
}

//+ (UIImage *)getImage:(NSString *)imageName
//{
//    UIImage * image = [UIImage imageWithContentsOfFile:[self path:imageName]];
//    return image;
//}

+ (NSString *)path:(NSString *)fileName
{
    NSString * bundlePath = [[NSBundle bundleForClass:self] bundlePath];
    NSString * path = [NSString stringWithFormat:@"%@/LDBase.bundle/%@",bundlePath,fileName];
    return path;
}

@end
