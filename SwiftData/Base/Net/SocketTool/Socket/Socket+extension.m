//
//  Socket+extension.m
//  SwiftData
//
//  Created by lingda on 2019/1/2.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import "Socket+extension.h"

@implementation Socket (extension)
-(BOOL)startTSL {
    NSMutableDictionary *sslSettings = [[NSMutableDictionary alloc] init];
    //获取证书内容 设置到socket
    NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ios_client" ofType:@"p12"]];
    if (nil == pkcs12data)
    {
        NSLog(@"获取本地p12文件失败");
        return NO;
    }
    CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(pkcs12data);
    CFStringRef password = CFSTR("tclking");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
    CFRelease(options);
    CFRelease(password);
    if(securityError == errSecSuccess) {
        NSLog(@"用密码打开本地p12文件成功");
    } else {
        NSLog(@"用密码打开本地p12文件失败");
        CFRelease(items);
        return NO;
    }
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef myIdent = (SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
    SecIdentityRef  certArray[1] = { myIdent };
    CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
    
    
    [sslSettings setObject:(id)CFBridgingRelease(myCerts) forKey:(NSString *)kCFStreamSSLCertificates];
    [sslSettings setObject:NSStreamSocketSecurityLevelNegotiatedSSL forKey:(NSString *)kCFStreamSSLLevel];
    [sslSettings setObject:(id)kCFBooleanTrue forKey:@"kCFStreamSSLAllowsAnyRoot"];
    [sslSettings setObject:self.host forKey:(NSString *)kCFStreamSSLPeerName];
    [sslSettings setObject:[NSNumber numberWithBool:YES] forKey:@"kCFStreamSSLAllowsExpiredCertificates"];
    [sslSettings setObject:[NSNumber numberWithBool:YES] forKey:@"kCFStreamSSLAllowsExpiredRoots"];
    [sslSettings setObject:[NSNumber numberWithBool:YES] forKey:@"kCFStreamSSLValidatesCertificateChain"];
    
    [self.inputStream setProperty:sslSettings forKey:(__bridge NSString *) kCFStreamPropertySSLSettings];
    [self.outputStream setProperty:sslSettings forKey:(__bridge NSString *) kCFStreamPropertySSLSettings];
    
    CFRelease(myIdent);
    CFRelease(myCerts);
    return YES;
}
@end
