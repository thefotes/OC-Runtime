//
//  OCRuntimeWrapper.m
//  OC-Runtime
//
//  Created by Peter Foti on 11/11/13.
//  Copyright (c) 2013 Peter Foti. All rights reserved.
//

#import "OCRuntimeWrapper.h"
#import <objc/runtime.h>

@interface OCRuntimeWrapper ()

@property (strong, nonatomic) id allocatedClass;
@property (assign, nonatomic) Class theClass;

@end
@implementation OCRuntimeWrapper

+ (instancetype)sharedWrapper
{
    static id sharedWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWrapper = [[OCRuntimeWrapper alloc] init];
    });
    return sharedWrapper;
}


- (id)allocatedClass
{
    if (!_allocatedClass) {
        static id allocatedClass = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            allocatedClass = [[NSObject alloc] init];
        });
        _allocatedClass = allocatedClass;
    }
    return _allocatedClass;
}

- (void)allocateClassWithName:(NSString *)className fromSuperClass:(Class)superClass
{
    _theClass = objc_allocateClassPair(superClass, [className cStringUsingEncoding:NSUTF8StringEncoding], 0);
}

- (BOOL)addInstanceVariableWithName:(NSString *)iVarName toClass:(id)theClass
{
    BOOL success = class_addIvar(_theClass, [iVarName cStringUsingEncoding:NSUTF8StringEncoding], sizeof(iVarName), rint(log2(sizeof(iVarName))), @encode(id));
    
    if (success) {
        return YES;
        
    } else {
        return NO;
    }
}

- (BOOL)createSetterAndGetterForIvarNamed:(NSString *)iVarName onClass:(id)theClass
{
    __block Ivar var = class_getInstanceVariable(_theClass, [iVarName cStringUsingEncoding:NSUTF8StringEncoding]);
//    __block id allocClass = _theClass;
    
    IMP setter = imp_implementationWithBlock(^(id self, SEL _cmd){
        object_setIvar(_theClass, var, @"asdf");
    });
    
    IMP getter = imp_implementationWithBlock(^id (id self, SEL _cmd){
        return object_getIvar(self, var);
    });
    
    class_addMethod(_theClass, NSSelectorFromString(@"setNamez:"), setter, "v@:@");
    BOOL su = class_addMethod(_theClass, NSSelectorFromString(@"boobs"), getter, "v@:");
    
    unsigned int counti;
    Method *method = class_copyMethodList(_theClass, &counti);
    for (int i = 0; i < counti; i++) {
        const char *methodName = sel_getName(method_getName(method[i]));
        NSLog(@"%@", [NSString stringWithUTF8String:methodName]);
    }

    if (su) {
        NSLog(@"suc");
    } else {
        NSLog(@"failure");
    }
    return YES;
}

- (id)classWithClass
{
    objc_registerClassPair(_theClass);
    return _theClass;
}
@end
