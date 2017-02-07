//
//  LivingInfoView.m
//  SlidPageDemo
//
//  Created by cuctv-duan on 16/8/26.
//  Copyright © 2016年 cuctv-duan. All rights reserved.
//

#import "LivingInfoView.h"

#define Screen_width [UIScreen mainScreen].bounds.size.width
@implementation LivingInfoView

#pragma mark - 直播信息界面的滑动

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    水平手势判断
    
    if (self.frame.origin.x > Screen_width * 0.2) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect frame = self.frame;
            frame.origin.x = Screen_width;
            self.frame = frame;
            
        }];
        
    }else{
        [UIView animateWithDuration:0.06 animations:^{
            CGRect frame = self.frame;
            frame.origin.x = 0;
            self.frame = frame;
        }];
    }
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (self.frame.origin.x > Screen_width * 0.2) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect frame = self.frame;
            frame.origin.x = Screen_width;
            self.frame = frame;
            
        }];
        
    }else{
        [UIView animateWithDuration:0.06 animations:^{
            CGRect frame = self.frame;
            frame.origin.x = 0;
            self.frame = frame;
        }];
    }
    
}

@end
