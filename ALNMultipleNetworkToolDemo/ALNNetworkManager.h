//
//  ALNNetworkManager.h
//  DNSAPP
//
//  Created by Avatar on 16/4/1.
//  Copyright © 2016年 ALN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALNNetworkManager;
@protocol ALNNetworkManagerDelegate;

@interface ALNNetworkManager : NSObject
/**
 default is 5;
 */
@property (nonatomic, assign) NSInteger maxCountOfAsynchronousRequest;
@property (nonatomic, strong) NSMutableArray *parametersArray;
@property (nonatomic, weak) id<ALNNetworkManagerDelegate> delegate;

+ (instancetype)networkManager;
- (void)start;
- (void)startWithParametersArray:(NSMutableArray *)parametersArray;
- (void)cancelAllRequest;
@end

@protocol ALNNetworkManagerDelegate <NSObject>
- (void)networkManager:(ALNNetworkManager *)manager SuccessWithResponseObject:(id)responseObject parameter:(NSDictionary *)parameter;
- (void)networkManager:(ALNNetworkManager *)manager FailedWithError:(NSError *)Error parameter:(NSDictionary *)parameter;
- (void)networkAllRequestFinished:(ALNNetworkManager *)manager;
@end