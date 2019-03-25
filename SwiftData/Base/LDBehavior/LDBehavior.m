//
//  Behavior.m
//  btc
//
//  Created by lingda on 2017/9/1.
//  Copyright © 2017年 btc. All rights reserved.
//

#import "LDBehavior.h"
#import <objc/runtime.h>

@implementation LDBehavior
- (void)setOwner:(id)owner
{
    if (_owner != owner) {
        [self releaseLifetimeFromObject:_owner];
        _owner = owner;
        [self bindLifetimeToObject:_owner];
    }
}

- (void)bindLifetimeToObject:(id)object
{
    objc_setAssociatedObject(object, (__bridge void *)self, self,   OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)releaseLifetimeFromObject:(id)object
{
    objc_setAssociatedObject(object, (__bridge void *)self, nil,    OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)check
{
    return YES;
}

@end
