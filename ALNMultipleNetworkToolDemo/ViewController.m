//
//  ViewController.m
//  ALNMultipleNetworkToolDemo
//
//  Created by Avatar on 16/6/12.
//  Copyright © 2016年 ALN. All rights reserved.
//

#import "ViewController.h"
#import "ALNNetworkManager.h"
@interface ViewController ()<ALNNetworkManagerDelegate>
@property (nonatomic, strong) ALNNetworkManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [ALNNetworkManager networkManager];
    self.manager.delegate = self;
    
    NSMutableArray *parametersArray = @[].mutableCopy;
    for(NSInteger index = 0;index < 100;index++){
        NSDictionary *dict = @{};
        [parametersArray addObject:dict];
    }
    self.manager.parametersArray = parametersArray;

}
- (IBAction)start:(id)sender {
//        [self.manager startWithParamsArray:parametersArray];
    [self.manager start];
}
- (IBAction)stop:(id)sender {
    [self.manager cancelAllRequest];
}

#pragma mark - ALNNetworkManagerDelegate
- (void)networkManager:(ALNNetworkManager *)manager SuccessWithResponseObject:(id)responseObject parameter:(NSDictionary *)parameter{
    NSLog(@"one successed");
}
- (void)networkManager:(ALNNetworkManager *)manager FailedWithError:(NSError *)Error parameter:(NSDictionary *)parameter{
    NSLog(@"one failed");
}

- (void)networkAllRequestFinished:(ALNNetworkManager *)manager{
    NSLog(@"All finished");
}
@end
