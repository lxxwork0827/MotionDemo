//
//  ViewController.m
//  MotionDemo
//
//  Created by 刘星星 on 16/7/4.
//  Copyright © 2016年 Phealth. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
@property (strong, nonatomic) CMMotionManager *motionManager;

@property (assign, nonatomic) BOOL isLandScape;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isLandScape = NO;
    
    [self initMotionManager];

}

/**
 *  在真机关闭屏幕旋转功能时如何去判断屏幕方向
 */
- (void)initMotionManager
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    
    // 提供设备运动数据到指定的时间间隔
    _motionManager.deviceMotionUpdateInterval = .3;
    //    _motionManager.accelerometerAvailable
    if (_motionManager.deviceMotionAvailable) {  // 确定是否使用任何可用的态度参考帧来决定设备的运动是否可用
        // 启动设备的运动更新，通过给定的队列向给定的处理程序提供数据。
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }else
    {
        [self setMotionManager:nil];
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    
    if (fabs(y) >= fabs(x))
    {   //NSLog(@"竖屏");
        if (self.isLandScape == YES) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];//这句话是防止手动先把设备置为竖屏,导致下面的语句失效.
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            self.isLandScape = NO;
        }
    }
    else
    {        //NSLog(@"横屏");
        if (self.isLandScape == NO) {
            
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];//这句话是防止手动先把设备置为横屏,导致下面的语句失效.
            
            if(x > 0){
                
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
            }
            else {
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
            }
            
            self.isLandScape = YES;
        }
    }
}

// 强制旋转
- (IBAction)tranfromOnClick:(UIButton *)sender
{
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait)
    {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];//这句话是防止手动先把设备置为横屏,导致下面的语句失效.
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    } else {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];//这句话是防止手动先把设备置为竖屏,导致下面的语句失效.
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }
}



//// 视图显示为横屏状态
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
//}
//
//-(BOOL)shouldAutorotate {
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}


@end
