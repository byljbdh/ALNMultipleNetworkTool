//
//  ALNMutipleNetworkTool.m
//  Queue
//
//  Created by Avatar on 16/3/31.
//  Copyright © 2016年 ALN. All rights reserved.
//

#import "ALNMutipleNetworkTool.h"
@interface ALNMutipleNetworkTool ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation ALNMutipleNetworkTool
- (void)dealloc{
    NSLog(@"%@___%s",self.name,__func__);
}
+ (instancetype)mutipleNetworkToolWithParamsArray:(NSMutableArray *)ParamsArray{
    return [[self alloc]initWithParamsArray:ParamsArray];
}
- (instancetype)initWithParamsArray:(NSMutableArray *)ParamsArray{
    if(self = [super init]){
        self.paramsArray = ParamsArray;
        [self baseSetUp];
    }
    return self;
}
- (instancetype)init{
    if(self = [super init]){
        [self baseSetUp];
    }
    return self;
}

- (void)baseSetUp{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.manager.requestSerializer.timeoutInterval = 15.0f;
}
- (void)startWithSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, id parameter))success
                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id parameter))failure{
    
    __weak typeof(self)weakself = self;
    NSLog(@"%@--sendRequest",weakself.name);
    
    if (self.isCancelled) {
        NSLog(@"%@--- requests cancelled",self.name);
        if([self.delegate respondsToSelector:@selector(mutipleNetworkToolFinsihedAllTasks:)]){
            [self.delegate mutipleNetworkToolFinsihedAllTasks:self];
        }
        return;
    }
    
    if (self.paramsArray.count){
        NSDictionary *dict = self.paramsArray.firstObject;
#warning use your url 
        NSString *urlString = @"https://www.baidu.com";
        [weakself.manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [weakself.paramsArray removeObjectAtIndex:0];
            NSLog(@"%@---%@",self.name,responseObject);
            success(task,responseObject,dict);
            
            [weakself startWithSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject, id parameter) {
                success(task, responseObject, parameter);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error, id parameter) {
                failure(task, responseObject, parameter);
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [weakself.paramsArray removeObjectAtIndex:0];
            NSLog(@"%@---%@",self.name,error);
            failure(task, error, dict);
            
            [weakself startWithSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject, id parameter) {
                success(task, responseObject, parameter);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error, id parameter) {
                failure(task, error, parameter);
            }];
            
        }];
    }else{
        NSLog(@"%@--- requests done",self.name);
        if([self.delegate respondsToSelector:@selector(mutipleNetworkToolFinsihedAllTasks:)]){
            [self.delegate mutipleNetworkToolFinsihedAllTasks:self];
        }
    }
}

@end
