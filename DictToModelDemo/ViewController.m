//
//  ViewController.m
//  DictToModelDemo
//
//  Created by ChenMan on 2018/5/8.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import "ViewController.h"

#import "NSObject+EnumDictOneLevel.h"

#import "Status.h"
#import "PersonModel.h"

@interface ViewController ()

@property (nonatomic, copy) NSMutableArray *statuses;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - test for cm_modelWithDict1
//    NSDictionary *dict = @{
//                           @"iconStr":@"小明",
//                           @"showStr":@"这是我的第一条心情"
//                           };
//    PersonModel *testPerson = [PersonModel cm_modelWithDict1:dict];
//    // 测试数据
//    NSLog(@"%@",testPerson);

    
#pragma mark - test for NSObject+EnumDict
    // 解析Plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"statuses.plist" ofType:nil];
    NSDictionary *statusDict = [NSDictionary dictionaryWithContentsOfFile:filePath];

    // 获取字典数组
    NSArray *dictArr = statusDict[@"statuses"];
    NSMutableArray *statusArr = [NSMutableArray array];

    // 遍历字典数组
    for (NSDictionary *dict in dictArr) {

        Status *status = [Status cm_modelWithDict:dict];

        [statusArr addObject:status];
    }
    NSLog(@"%@",statusArr);

    
#pragma mark - test for NSObject+EnumArr
//    // 解析Plist文件
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"statuses.plist" ofType:nil];
//    NSDictionary *statusDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
//
//    // 获取字典数组
//    NSArray *dictArr = statusDict[@"statuses"];
//    _statuses = [NSMutableArray array];
//
//    // 遍历字典数组
//    for (NSDictionary *dict in dictArr) {
//
//        Status *status = [Status modelWithDict:dict];
//
//        [_statuses addObject:status];
//    }
//
//    NSLog(@"%@",_statuses);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
