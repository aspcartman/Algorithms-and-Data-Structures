//
//  main.m
//  Algorithms and Data Structures
//
//  Created by ASPCartman on 27/11/14.
//  Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>

int main(int argc, const char * argv[]) {
	unsigned int varCount;
	Ivar *vars = class_copyIvarList([@(1) class], &varCount);
    return 0;
}

