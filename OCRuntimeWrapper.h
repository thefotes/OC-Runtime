//
//  OCRuntimeWrapper.h
//  OC-Runtime
//
//  Created by Peter Foti on 11/11/13.
//  Copyright (c) 2013 Peter Foti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCRuntimeWrapper : NSObject

+ (instancetype)sharedWrapper;

- (void)allocateClassWithName:(NSString *)className fromSuperClass:(Class)superClass;
- (BOOL)addInstanceVariableWithName:(NSString *)iVarName toClass:(id)theClass;
- (BOOL)createSetterAndGetterForIvarNamed:(NSString *)iVarName onClass:(id)theClass;
- (id)classWithClass;

@end
