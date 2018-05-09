//
//  Status.m
//  DictToModelDemo
//
//  Created by ChenMan on 2018/5/8.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import "Status.h"

@implementation Status

+ (NSDictionary *)arrayContainModelClass
{
    return @{@"cellMdlArr" : @"CellModel"};
}

+ (NSDictionary *)dictWithModelClass
{
    return @{@"person" : @"PersonModel"};
}

@end
