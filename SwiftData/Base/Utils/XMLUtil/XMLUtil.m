//
//  XMLTool
//  TclIntelliCom
//
//  Created by lingda on 2018/11/8.
//  Copyright © 2018年 tcl. All rights reserved.
//

#import "XMLUtil.h"
#import "XMLWriter.h"
#import "XMLReader.h"
#import "GDataXMLNode.h"
#import "NSString+str2Dic2str.h"

@implementation XMLUtil

/*
 将
 <confing>
    <attr>
        <name>1</name>
        <address>2</address>
    </attr>
 </config>
 转化成
 <config name='1' address='2'></config>
 */
+(void)handleElementAttr:(GDataXMLElement*)element{
    NSMutableArray * shouldRemoveEle = [NSMutableArray array];
    for (GDataXMLElement*c in element.children) {
        if ([c.name isEqualToString:@"attr"]) {
            for (GDataXMLElement * c1 in c.children) {
                [element addAttribute:c1];
            }
            [shouldRemoveEle addObject:c];
        }
    }
    for (GDataXMLElement * el in shouldRemoveEle) {
        [element removeChild:el];
    }
    for (GDataXMLElement*e in element.children) {
        [self handleElementAttr:e];
    }
}
/*
 将下面的格式
 <a aa="aa">
    <b>b<b/>
    <c>c<c/>
    </d>
 </a>
 转为
 <a aa="aa" b="b" c="c" d="">
 
 如果出现了
 <a aa="aa">
    <b bb="bb">b<b/>
 </a>
 应该是会出问题的，目前未发现项目中有这样的格式
 */
+ (void)handElementText:(GDataXMLElement *)superEle {
    NSMutableArray *sum = @[].mutableCopy;
    for (GDataXMLElement * child in superEle.children) {
        if ((child.children.count == 1 && [child.children.firstObject children] == nil &&
            [[child.children.firstObject name] isEqualToString:@"text"]) || child.children == nil) {
            [sum addObject:child];
            [superEle addAttribute:child];
        }
    }
    for (GDataXMLElement *el in sum) {
        [superEle removeChild:el];
    }
    
    for (GDataXMLElement * el in superEle.children) {
        [self handElementText:el];
    }
}

+(NSString *)XMLFromJson:(NSString *)jsonStr {
    NSDictionary *dic = jsonStr.dictionary;
    NSString * xmlStr = [XMLWriter XMLStringFromDictionary:dic];
    NSError *err;
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr error:&err];
    GDataXMLElement * rootEle = doc.rootElement;
    [self handleElementAttr:rootEle];
    NSString * result = rootEle.XMLString;
    return result;
}


+ (NSDictionary *)dicFromXML:(NSString *)xmlStr {
    NSError * error = nil;
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr error:&error];
    [self handElementText:doc.rootElement];
    NSString * convertXmlStr = doc.rootElement.XMLString;
    NSDictionary * dict;
    dict = [XMLReader dictionaryForXMLString:convertXmlStr error:&error];
    return dict;
}

@end
