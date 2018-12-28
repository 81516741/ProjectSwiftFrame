//
//  NSObject+dealloc.m
//  weak属性runtime实现
//
//  Created by ld on 17/2/17.
//  Copyright © 2017年 ld. All rights reserved.
//

#import "NSObject+LDMonitor.h"
#import <objc/runtime.h>
@implementation NSObject (LDMonitor)
@dynamic deallocBlock;

- (void)setDeallocBlock:(dispatch_block_t)deallocBlock
{
    LDObject * object = [[LDObject alloc]initWithBlock:deallocBlock];
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN);
}


@end

@implementation LDObject

- (instancetype)initWithBlock:(dispatch_block_t)block
{
    if (self = [super init]) {
        _deallocBlockLDObject = [block copy];
    }
    return self;
}

- (void)dealloc
{
    _deallocBlockLDObject ? _deallocBlockLDObject() : nil;    
}

@end
