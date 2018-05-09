//
//  NSObject+Convert.h
//  DictToModelDemo
//
//  Created by ChenMan on 2018/5/8.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EnumDict)

+ (instancetype)cm_modelWithDict:(NSDictionary *)dict;

@end
