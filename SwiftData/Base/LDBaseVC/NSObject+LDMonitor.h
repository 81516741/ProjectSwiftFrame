//
//  NSObject+dealloc.h
//  weak属性runtime实现
//
//  Created by ld on 17/2/17.
//  Copyright © 2017年 ld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LDMonitor)

@property (nonatomic,copy) dispatch_block_t deallocBlock;

@end


@interface LDObject : NSObject

-(instancetype)initWithBlock:(dispatch_block_t)block;
@property (nonatomic,copy) dispatch_block_t deallocBlockLDObject;

@end
