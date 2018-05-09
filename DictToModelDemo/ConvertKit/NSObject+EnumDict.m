//
//  NSObject+Convert.m
//  DictToModelDemo
//
//  Created by ChenMan on 2018/5/8.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import "NSObject+EnumDict.h"

//导入模型
#import "Status.h"
#import <objc/runtime.h>

@implementation NSObject (EnumDict)

const char *kCMPropertyListKey = "CMPropertyListKey";

+ (instancetype)cm_modelWithDict:(NSDictionary *)dict
{
    /* 实例化对象 */
    id model = [[self alloc]init];
    
    /* 使用字典,设置对象信息 */
    /* 1. 获得 self 的属性列表 */
    NSArray *propertyList = [self cm_objcProperties];
    
    /* 2. 遍历字典 */
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        /* 3. 判断 key 是否字 propertyList 中 */
        if ([propertyList containsObject:key]) {
            
            // 获取成员属性类型
            // 类型经常变，抽出来
            NSString *ivarType;
            
            if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
                ivarType = @"NSString";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
                ivarType = @"NSArray";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
                ivarType = @"int";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
                ivarType = @"NSDictionary";
            }
            
            // 二级转换,字典中还有字典,也需要把对应字典转换成模型
            // 判断下value,是不是字典
            if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) { //  是字典对象,并且属性名对应类型是自定义类型
                // value:user字典 -> User模型
                // 获取模型(user)类对象
                NSString *ivarType = [Status dictWithModelClass][key];
                Class modalClass = NSClassFromString(ivarType);
                
                // 字典转模型
                if (modalClass) {
                    // 字典转模型 user
                    obj = [modalClass cm_modelWithDict:obj];
                }
                
            }
            
            // 三级转换：NSArray中也是字典，把数组中的字典转换成模型.
            // 判断值是否是数组
            if ([obj isKindOfClass:[NSArray class]]) {
                // 判断对应类有没有实现字典数组转模型数组的协议
                if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                    
                    // 转换成id类型，就能调用任何对象的方法
                    id idSelf = self;
                    
                    // 获取数组中字典对应的模型
                    NSString *type =  [idSelf arrayContainModelClass][key];
                    
                    // 生成模型
                    Class classModel = NSClassFromString(type);
                    NSMutableArray *arrM = [NSMutableArray array];
                    // 遍历字典数组，生成模型数组
                    for (NSDictionary *dict in obj) {
                        // 字典转模型
                        id model =  [classModel cm_modelWithDict:dict];
                        [arrM addObject:model];
                    }
                    
                    // 把模型数组赋值给value
                    obj = arrM;
                    
                }
            }
            
            // KVC字典转模型
            if (obj) {
                /* 说明属性存在,可以使用 KVC 设置数值 */
                [model setValue:obj forKey:key];
            }
        }
        
    }];
    
    /* 返回对象 */
    return model;
}

+ (NSArray *)cm_objcProperties
{
    /* 获取关联对象 */
    NSArray *ptyList = objc_getAssociatedObject(self, kCMPropertyListKey);
    
    /* 如果 ptyList 有值,直接返回 */
    if (ptyList) {
        return ptyList;
    }
    /* 调用运行时方法, 取得类的属性列表 */
    /* 成员变量:
     * class_copyIvarList(__unsafe_unretained Class cls, unsigned int *outCount)
     * 方法:
     * class_copyMethodList(__unsafe_unretained Class cls, unsigned int *outCount)
     * 属性:
     * class_copyPropertyList(__unsafe_unretained Class cls, unsigned int *outCount)
     * 协议:
     * class_copyProtocolList(__unsafe_unretained Class cls, unsigned int *outCount)
     */
    unsigned int outCount = 0;
    /**
     * 参数1: 要获取得类
     * 参数2: 雷属性的个数指针
     * 返回值: 所有属性的数组, C 语言中,数组的名字,就是指向第一个元素的地址
     */
    /* retain, creat, copy 需要release */
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *mtArray = [NSMutableArray array];
    
    /* 遍历所有属性 */
    for (unsigned int i = 0; i < outCount; i++) {
        /* 从数组中取得属性 */
        objc_property_t property = propertyList[i];
        /* 从 property 中获得属性名称 */
        const char *propertyName_C = property_getName(property);
        /* 将 C 字符串转化成 OC 字符串 */
        NSString *propertyName_OC = [NSString stringWithCString:propertyName_C encoding:NSUTF8StringEncoding];
        [mtArray addObject:propertyName_OC];
    }
    
    /* 设置关联对象 */
    /**
     *  参数1 : 对象self
     *  参数2 : 动态添加属性的 key
     *  参数3 : 动态添加属性值
     *  参数4 : 对象的引用关系
     */
    
    objc_setAssociatedObject(self, kCMPropertyListKey, mtArray.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    /* 释放 */
    free(propertyList);
    return mtArray.copy;
    
}


@end
