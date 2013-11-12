//
//  OCRViewController.m
//  OC-Runtime
//
//  Created by Peter Foti on 11/11/13.
//  Copyright (c) 2013 Peter Foti. All rights reserved.
//

#import "OCRViewController.h"
#import "OCRuntimeWrapper.h"

@interface OCRViewController ()

@end

@implementation OCRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    OCRuntimeWrapper *wrap = [OCRuntimeWrapper sharedWrapper];

    [wrap allocateClassWithName:@"myClass" fromSuperClass:[NSObject class]];
    [wrap addInstanceVariableWithName:@"boobs" toClass:wrap];
    [wrap createSetterAndGetterForIvarNamed:@"boobs" onClass:wrap];
    id myClass = [[[wrap classWithClass] alloc] init];
    [myClass performSelector:@selector(setNamez:) withObject:@"peter"];
    
    NSLog(@"Name: %@", [myClass performSelector:NSSelectorFromString(@"boobs") withObject:nil]);

}

@end
