//
//  Socket.m
//  SwiftData
//
//  Created by lingda on 2018/12/21.
//  Copyright © 2018年 lingda. All rights reserved.
//

#import "Socket.h"
@interface Socket()<NSStreamDelegate>
@property(strong, nonatomic) NSInputStream * inputStream;
@property(strong, nonatomic) NSOutputStream * outputStream;
@property(strong, nonatomic) dispatch_queue_t readQueue;
@property(strong, nonatomic) dispatch_queue_t writeQueue;
@property(copy, nonatomic) NSString * host;
@property(assign, nonatomic) UInt16 port;
@property(assign, nonatomic) BOOL isOpenInputStream;
@property(assign, nonatomic) BOOL isOpenOutputStream;
@end

@implementation Socket
- (instancetype)init {
    self = [super init];
    if (self) {
        self.readQueue = dispatch_queue_create("socket回包的队列",NULL);
        self.writeQueue = dispatch_queue_create("socket发送消息的队列",NULL);
        self.isOpenInputStream = NO;
        self.isOpenOutputStream = NO;
    }
    return self;
}

-(void)connect:(NSString *)host toPort:(UInt16)port {
    [self resetSocket];
    CFReadStreamRef   readStream;
    CFWriteStreamRef  writeStram;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host,(int)port,&readStream, &writeStram);
    if (readStream == nil || writeStram == nil) {
        if (self.connectResult) {
            self.connectResult(NO);
        }
        return;
    }
    _host = host;
    _port = port;
    _inputStream = (__bridge NSInputStream *)readStream;
    _outputStream = (__bridge NSOutputStream *)writeStram;
    _inputStream.delegate = self;
    _outputStream.delegate = self;
    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
}

- (void)send:(NSData *)data {
    if(nil == data) {
        if (self.sendResult) {
            self.sendResult(NO);
            return;
        }
    }
    if(nil == _outputStream) {
        if (self.sendResult) {
            self.sendResult(NO);
            return;
        }
    }
    dispatch_async(self.writeQueue, ^{
        NSInteger sendLen = [self.outputStream write:data.bytes maxLength:data.length];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(sendLen != data.length) {
                if (self.sendResult) {
                    self.sendResult(NO);
                }
            } else {
                if (self.sendResult) {
                    self.sendResult(YES);
                }
            }
        });
    });
}
-(BOOL)recvData {
    static unsigned char * rcvBuff=NULL;
    static int rcvBuffLen=0;
    if(NULL==rcvBuff) {
        rcvBuff=(unsigned char *)malloc(1024*10);
    }
    uint8_t dataBuf[4096];
    NSInteger dataLen;
    dataLen=[_inputStream read:dataBuf maxLength:sizeof(dataBuf)];
    if(dataLen<=0) {
        return NO;
    }
    memcpy(rcvBuff+rcvBuffLen,dataBuf,dataLen);
    rcvBuffLen+=dataLen;
    if(rcvBuffLen<=0) {
        return NO;
    }
    NSData *rcvData=[NSData dataWithBytes:rcvBuff length:rcvBuffLen];
    NSString *rcvString=[[NSString alloc]initWithData:rcvData encoding:NSUTF8StringEncoding];
    if(nil==rcvString) {
        if(rcvBuffLen>=1024*9) {
            rcvBuffLen=0;
        }
    } else {
        rcvBuffLen=0;
        if (self.msgResult) {
            dispatch_async(dispatch_get_main_queue(), ^{
               self.msgResult(rcvString);
            });
        }
    }
    return YES;
}

-(void)close {
    [self resetSocket];
    if (self.connectResult) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.connectResult(false);
        });
    }
}
- (void)resetSocket {
    [_inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream close];
    [_outputStream close];
    _inputStream = nil;
    _outputStream = nil;
    _isOpenInputStream = NO;
    _isOpenOutputStream = NO;
}
#pragma mark NSStreamDelegate
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
   switch (eventCode) {
       case NSStreamEventOpenCompleted:
           //输入输出流打开完成
           if (aStream == self.inputStream) {
               self.isOpenInputStream = YES;
           }
           if (aStream == self.outputStream) {
               self.isOpenOutputStream = YES;
           }
           if (self.isOpenInputStream &&
               self.isOpenOutputStream) {
               if (self.connectResult) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       NSLog(@"连接成功");
                       self.connectResult(true);
                   });
               }
           }
           break;
       case NSStreamEventHasBytesAvailable:{
           //有字节可读
           dispatch_async(self.readQueue, ^{
               [self recvData];
           });
           break;
       }
       case NSStreamEventHasSpaceAvailable:
           //可以发放字节
           break;
       case NSStreamEventErrorOccurred:
           //连接出现错误（断网会来这里）
           if (aStream == self.inputStream) {
               self.isOpenInputStream = NO;
           }
           if (aStream == self.outputStream) {
               self.isOpenOutputStream = NO;
           }
           if (!self.isOpenInputStream &&
               !self.isOpenOutputStream) {
               NSLog(@"连接错误");
               [self resetSocket];
               if (self.connectResult) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       self.connectResult(false);
                   });
               }
           }
           break;
       case NSStreamEventEndEncountered:
           // 连接结束（服务器主动断开会来这里-心跳不及时）
           if (aStream == self.inputStream) {
               self.isOpenInputStream = NO;
           }
           if (aStream == self.outputStream) {
               self.isOpenOutputStream = NO;
           }
           if (!self.isOpenInputStream &&
               !self.isOpenOutputStream) {
               NSLog(@"连接结束");
               [self resetSocket];
               if (self.connectResult) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       self.connectResult(false);
                   });
               }
           }
           break;
       default:
           break;
   }
}

#pragma mark - TSL
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
    
    [_inputStream setProperty:sslSettings forKey:(__bridge NSString *) kCFStreamPropertySSLSettings];
    [_outputStream setProperty:sslSettings forKey:(__bridge NSString *) kCFStreamPropertySSLSettings];
    
    CFRelease(myIdent);
    CFRelease(myCerts);
    return YES;
}
@end
