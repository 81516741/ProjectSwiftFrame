//
//  NSString+str2Dic2str.m
//  TclIntelliCom
//
//  Created by lingda on 2018/11/7.
//  Copyright © 2018年 tcl. All rights reserved.
//

#import "NSString+str2Dic2str.h"

@implementation NSString (str2Dic2str)
- (NSDictionary *)dictionary {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end


@implementation NSDictionary (str2Dic2str)
- (NSString *)json {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end
