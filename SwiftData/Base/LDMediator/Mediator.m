//
//  Mediator.m
//  MainArch_Example
//
//  Created by 令达 on 2018/3/26.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "Mediator.h"
#import <objc/runtime.h>

@interface Mediator ()
    
@property (nonatomic, strong) NSMutableDictionary *cachedTarget;
    
@end

@implementation Mediator
#pragma mark - public methods
+ (instancetype)sharedInstance
    {
        static Mediator *mediator;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mediator = [[Mediator alloc] init];
        });
        return mediator;
    }
    
    /*
     scheme://[target]/[action]?[params]
     
     url sample:
     aaa://targetA/actionB?id=1234
     */
    
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSString *urlString = [url query];
        for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts lastObject] forKey:[elts firstObject]];
        }
        
        // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
        NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if ([actionName hasPrefix:@"native"]) {
            return @(NO);
        }
        
        // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
        id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
        if (completion) {
            if (result) {
                completion(@{@"result":result});
            } else {
                completion(nil);
            }
        }
        return result;
    }
    
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget
    {
        //1、获取目标对象
        Class targetClass;
        NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
        NSObject *target = self.cachedTarget[targetClassString];
        if (target == nil) {
            targetClass = NSClassFromString(targetClassString);
            target = [[targetClass alloc] init];
            if (target == nil) {
                //Swift
                NSString * executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
                targetClassString = [NSString stringWithFormat:@"%@.%@",executableFile,targetClassString];
                targetClass = NSClassFromString(targetClassString);
                target = [[targetClass alloc] init];
            }
        }
        //2、获取目标对象的方法并执行
        SEL action = NSSelectorFromString([NSString stringWithFormat:@"Action_%@:", actionName]);
        SEL actionSwift = NSSelectorFromString( [NSString stringWithFormat:@"Action_%@WithParams:", actionName]);
        if (target == nil) {
            //无法创建指定对象
            return nil;
        }
        
        if (shouldCacheTarget) {
            self.cachedTarget[targetClassString] = target;
        }
        
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            if ([target respondsToSelector:actionSwift]) {
                //Swift
                return [self safePerformAction:actionSwift target:target params:params];
            } else {
                //没有找到目标方法
                action = NSSelectorFromString(@"noMethod:");
                actionSwift = NSSelectorFromString(@"noMethodWithParams:");
                if ([target respondsToSelector:action]) {
                    return [self safePerformAction:action target:target params:params];
                }else if ([target respondsToSelector:actionSwift]) {
                    return [self safePerformAction:actionSwift target:target params:params];
                } else {
                    // noMethod:  都没有
                    [self.cachedTarget removeObjectForKey:targetClassString];
                    return nil;
                }
            }
        }
    }
    
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName
    {
        NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
        [self.cachedTarget removeObjectForKey:targetClassString];
    }
    
#pragma mark - private methods
- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
    {
        NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
        if(methodSig == nil) {
            return nil;
        }
        const char* retType = [methodSig methodReturnType];
        
        if (strcmp(retType, @encode(void)) == 0) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
            [invocation setArgument:&params atIndex:2];
            [invocation setSelector:action];
            [invocation setTarget:target];
            [invocation invoke];
            return nil;
        }
        
        if (strcmp(retType, @encode(NSInteger)) == 0) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
            [invocation setArgument:&params atIndex:2];
            [invocation setSelector:action];
            [invocation setTarget:target];
            [invocation invoke];
            NSInteger result = 0;
            [invocation getReturnValue:&result];
            return @(result);
        }
        
        if (strcmp(retType, @encode(BOOL)) == 0) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
            [invocation setArgument:&params atIndex:2];
            [invocation setSelector:action];
            [invocation setTarget:target];
            [invocation invoke];
            BOOL result = 0;
            [invocation getReturnValue:&result];
            return @(result);
        }
        
        if (strcmp(retType, @encode(CGFloat)) == 0) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
            [invocation setArgument:&params atIndex:2];
            [invocation setSelector:action];
            [invocation setTarget:target];
            [invocation invoke];
            CGFloat result = 0;
            [invocation getReturnValue:&result];
            return @(result);
        }
        
        if (strcmp(retType, @encode(NSUInteger)) == 0) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
            [invocation setArgument:&params atIndex:2];
            [invocation setSelector:action];
            [invocation setTarget:target];
            [invocation invoke];
            NSUInteger result = 0;
            [invocation getReturnValue:&result];
            return @(result);
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    }
    
#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget
    {
        if (_cachedTarget == nil) {
            _cachedTarget = [[NSMutableDictionary alloc] init];
        }
        return _cachedTarget;
    }


@end
