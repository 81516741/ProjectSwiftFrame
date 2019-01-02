//
//  Socket.h
//  SwiftData
//
//  Created by lingda on 2018/12/21.
//  Copyright © 2018年 lingda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Socket : NSObject
- (void)connect:(NSString *)host toPort:(UInt16)port;
- (void)send:(NSData *)data;
- (void)close;
@property(copy, nonatomic) void(^connectResult)(BOOL isConnected);
@property(copy, nonatomic) void(^sendResult)(BOOL isSended);
@property(copy, nonatomic) void(^msgResult)(NSString * msg);
@property(strong, nonatomic) NSInputStream * inputStream;
@property(strong, nonatomic) NSOutputStream * outputStream;
@property(copy, nonatomic) NSString * host;
@property(assign, nonatomic) UInt16 port;
@end

