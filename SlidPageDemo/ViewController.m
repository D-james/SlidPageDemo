//
//  ViewController.m
//  SlidPageDemo
//
//  Created by cuctv-duan on 16/8/26.
//  Copyright © 2016年 cuctv-duan. All rights reserved.
//

#import "ViewController.h"
#import "LivingInfoView.h"

#define Screen_width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (weak, nonatomic) LivingInfoView *livingInfoView;
@property (assign, nonatomic) BOOL isBeginSlid;//记录开始触摸的方向
@property (weak, nonatomic) UIImageView *playLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    播放层
    UIImageView *playLayer = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    [self.view addSubview:playLayer];
    self.playLayer = playLayer;
    
    playLayer.image = [UIImage imageNamed:@"PlayView"];
    playLayer.userInteractionEnabled = YES;
//    播放信息层
    LivingInfoView *livingInfoView = [[LivingInfoView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    [playLayer addSubview:livingInfoView];
    self.livingInfoView = livingInfoView;
    
    livingInfoView.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:156 / 255.0 blue:177 / 255.0 alpha:0.6];
}

#pragma mark - 界面的滑动
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isBeginSlid = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    //    1.获取手指
    UITouch *touch = [touches anyObject];
    //    2.获取触摸的上一个位置
    CGPoint lastPoint;
    CGPoint currentPoint;
    
    //    3.获取偏移位置
    CGPoint tempCenter;
    
    if (self.isBeginSlid) {//首次触摸进入
        lastPoint = [touch previousLocationInView:self.playLayer];
        currentPoint = [touch locationInView:self.playLayer];
        
        
        //判断是左右滑动还是上下滑动
        if (ABS(currentPoint.x - lastPoint.x) > ABS(currentPoint.y - lastPoint.y)) {
            //    3.获取偏移位置
            tempCenter = self.livingInfoView.center;
            tempCenter.x += currentPoint.x - lastPoint.x;//左右滑动
            //禁止向左划
            if (self.livingInfoView.frame.origin.x == 0 && currentPoint.x -lastPoint.x > 0) {//滑动开始是从0点开始的，并且是向右滑动
                self.livingInfoView.center = tempCenter;
                
            }
//            else if(self.livingInfoView.frame.origin.x > 0){
//                self.livingInfoView.center = tempCenter;
//            }
//            NSLog(@"%@-----%@",NSStringFromCGPoint(tempCenter),NSStringFromCGPoint(self.livingInfoView.center));
        }else{
            //    3.获取偏移位置
            tempCenter = self.playLayer.center;
            tempCenter.y += currentPoint.y - lastPoint.y;//上下滑动
            self.playLayer.center = tempCenter;
        }
    }else{//滑动开始后进入，滑动方向要么水平要么垂直
        if (self.playLayer.frame.origin.y != 0){//垂直的优先级高于左右滑，因为左右滑的判定是不等于0
            
            lastPoint = [touch previousLocationInView:self.playLayer];
            currentPoint = [touch locationInView:self.playLayer];
            tempCenter = self.playLayer.center;
            
            tempCenter.y += currentPoint.y -lastPoint.y;
            self.playLayer.center = tempCenter;
        }else if (self.livingInfoView.frame.origin.x != 0) {
            
            lastPoint = [touch previousLocationInView:self.livingInfoView];
            currentPoint = [touch locationInView:self.livingInfoView];
            tempCenter = self.livingInfoView.center;
            
            tempCenter.x += currentPoint.x -lastPoint.x;
            
            //禁止向左划

            if (self.livingInfoView.frame.origin.x == 0 && currentPoint.x -lastPoint.x > 0) {//滑动开始是从0点开始的，并且是向右滑动
                self.livingInfoView.center = tempCenter;
        
            }else if(self.livingInfoView.frame.origin.x > 0){
                self.livingInfoView.center = tempCenter;
            }
            
        }
    }
  
    self.isBeginSlid = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%.2f-----%.2f",livingInfoView.frame.origin.y,Screen_height * 0.8);
    
//    水平滑动判断
//在控制器这边滑动判断如果滑动范围没有超过屏幕的十分之八livingInfoView还是离开屏幕
    if (self.livingInfoView.frame.origin.x > Screen_width * 0.8) {
        [UIView animateWithDuration:0.06 animations:^{
            CGRect frame = self.livingInfoView.frame;
            frame.origin.x = Screen_width;
            self.livingInfoView.frame = frame;
        }];
        
    }else{//否则则回到屏幕0点
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.livingInfoView.frame;
            frame.origin.x = 0;
            self.livingInfoView.frame = frame;
            
        }];
    }
    
//    上下滑动判断
    if (self.playLayer.frame.origin.y > Screen_height * 0.2) {
//        切换到下一频道
        self.playLayer.image = [UIImage imageNamed:@"PlayView2"];
        
    }else if (self.playLayer.frame.origin.y < - Screen_height * 0.2){
//        切换到上一频道
         self.playLayer.image = [UIImage imageNamed:@"PlayView"];
        
    }
//        回到原始位置等待界面重新加载
    CGRect frame = self.playLayer.frame;
    frame.origin.y = 0;
    self.playLayer.frame = frame;
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //    水平滑动判断
    //在控制器这边滑动判断如果滑动范围没有超过屏幕的十分之八livingInfoView还是离开屏幕
    if (self.livingInfoView.frame.origin.x > Screen_width * 0.8) {
        [UIView animateWithDuration:0.06 animations:^{
            CGRect frame = self.livingInfoView.frame;
            frame.origin.x = Screen_width;
            self.livingInfoView.frame = frame;
        }];
        
    }else{//否则则回到屏幕0点
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.livingInfoView.frame;
            frame.origin.x = 0;
            self.livingInfoView.frame = frame;
            
        }];
    }
    
    //    上下滑动判断
    if (self.livingInfoView.frame.origin.y > Screen_height * 0.2) {
        //        切换到下一频道
        self.livingInfoView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:0.5];
        
    }else if (self.livingInfoView.frame.origin.y < - Screen_height * 0.2){
        //        切换到上一频道
        self.livingInfoView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:0.5];
        
    }
    //        回到原始位置等待界面重新加载
    CGRect frame = self.livingInfoView.frame;
    frame.origin.y = 0;
    self.livingInfoView.frame = frame;
}

@end
