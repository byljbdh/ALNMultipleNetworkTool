//
//  ALNNetworkManager.m
//  DNSAPP
//
//  Created by Avatar on 16/4/1.
//  Copyright © 2016年 ALN. All rights reserved.
//

#import "ALNNetworkManager.h"
#import "ALNMutipleNetworkTool.h"

@interface ALNNetworkManager ()<ALNMutipleNetworkToolDelegate>
@property (nonatomic, strong) NSMutableArray *networkToolsArray;
@property (nonatomic, assign) NSInteger finishedToolsCount;
@end
@implementation ALNNetworkManager

- (NSMutableArray *)networkToolsArray{
    if(!_networkToolsArray){
        _networkToolsArray = @[].mutableCopy;
    }
    return _networkToolsArray;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
+ (instancetype)networkManager{
    return [[self alloc]init];
}
- (instancetype)init{
    if(self = [super init]){
        self.maxCountOfAsynchronousRequest = 5;
        self.finishedToolsCount = 0;
    }
    return self;
}
- (void)setMaxCountOfAsynchronousRequest:(NSInteger)maxCountOfAsynchronousRequest{
    _maxCountOfAsynchronousRequest = maxCountOfAsynchronousRequest;
    NSAssert(maxCountOfAsynchronousRequest > 0, @"the count of tools should be more than 1");
    NSInteger currentCountOfTools = self.networkToolsArray.count;
    
    if(currentCountOfTools < maxCountOfAsynchronousRequest){
        for(NSInteger index = self.networkToolsArray.count; index < maxCountOfAsynchronousRequest; index++ ){
            ALNMutipleNetworkTool *networkTool = [[ALNMutipleNetworkTool alloc]init];
            networkTool.name = [NSString stringWithFormat:@"tool%zd",index];
            networkTool.delegate = self;
            [self.networkToolsArray addObject:networkTool];
        }
    }else{
        for(NSInteger index = currentCountOfTools; index > maxCountOfAsynchronousRequest; index--){
            [self.networkToolsArray removeObjectAtIndex:index - 1];
        }
    }
    NSLog(@"current count of tools , %zd",self.networkToolsArray.count);
}

//开始任务
- (void)start{
    NSAssert(self.parametersArray.count > 0, @"the count of paramsArray is not correct");
    [self startWithParametersArray:self.parametersArray];
}
- (void)startWithParametersArray:(NSMutableArray *)parametersArray{
    [self assignToolsWithParamsArray:parametersArray];
    for(ALNMutipleNetworkTool *tool in self.networkToolsArray){
        tool.cancel = NO;
        [tool startWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nonnull parameter) {
            if([self.delegate respondsToSelector:@selector(networkManager:SuccessWithResponseObject:parameter:)]){
                [self.delegate networkManager:self SuccessWithResponseObject:responseObject parameter:parameter];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error, id  _Nonnull parameter) {
            if([self.delegate respondsToSelector:@selector(networkManager:FailedWithError:parameter:)]){
                [self.delegate networkManager:self FailedWithError:error parameter:parameter];
            }
        }];
    }
}
//分配任务
- (void)assignToolsWithParamsArray:(NSMutableArray *)paramsArray{
    NSInteger paramsCount = paramsArray.count;
    NSInteger networkToolsCount = self.networkToolsArray.count;
    NSInteger averageCount = paramsCount / networkToolsCount;
    NSInteger lastOneToolParam = paramsCount - (networkToolsCount * averageCount) + averageCount;
    
    for(NSInteger index = 0; index < networkToolsCount; index++){
        ALNMutipleNetworkTool *networkTool = self.networkToolsArray[index];
        if(index != networkToolsCount - 1){
           networkTool.paramsArray = [paramsArray subarrayWithRange:NSMakeRange(index * averageCount, averageCount)].mutableCopy;
        }else{
            networkTool.paramsArray = [paramsArray subarrayWithRange:NSMakeRange(index * averageCount, lastOneToolParam)].mutableCopy;
        }
    }
}
- (void)cancelAllRequest{
    for(ALNMutipleNetworkTool *tool in self.networkToolsArray){
        tool.cancel = YES;
    }
}
#pragma mark - ALNMutipleNetworkToolDelegate
- (void)mutipleNetworkToolFinsihedAllTasks:(ALNMutipleNetworkTool *)mutipleNetworkTool{
    if(self.finishedToolsCount != self.networkToolsArray.count - 1){
        self.finishedToolsCount ++;
    }else{
        if([self.delegate respondsToSelector:@selector(networkAllRequestFinished:)]){
            [self.delegate networkAllRequestFinished:self];
        }
        self.finishedToolsCount = 0;
    }
}
@end
