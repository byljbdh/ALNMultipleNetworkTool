//
//  ALNMutipleNetworkTool.h
//  Queue
//
//  Created by Avatar on 16/3/31.
//  Copyright © 2016年 ALN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN

@class ALNMutipleNetworkTool;
@protocol ALNMutipleNetworkToolDelegate;

@interface ALNMutipleNetworkTool : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id<ALNMutipleNetworkToolDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *paramsArray;
@property (nonatomic, assign,getter=isCancelled) BOOL cancel;

+ (instancetype)mutipleNetworkToolWithParamsArray:(NSMutableArray *)ParamsArray;
- (instancetype)initWithParamsArray:(NSMutableArray *)ParamsArray;

//start Method
- (void)startWithSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, id parameter))success
                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error, id parameter))failure;
@end

@protocol ALNMutipleNetworkToolDelegate <NSObject>

- (void)mutipleNetworkToolFinsihedAllTasks:(ALNMutipleNetworkTool *)mutipleNetworkTool;

@end
NS_ASSUME_NONNULL_END