//
//  XMLTool
//  TclIntelliCom
//
//  Created by lingda on 2018/11/8.
//  Copyright © 2018年 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLUtil : NSObject
+(NSString *)XMLFromJson:(NSString *)jsonStr;
+(NSDictionary *)dicFromXML:(NSString *)xmlStr;
@end
