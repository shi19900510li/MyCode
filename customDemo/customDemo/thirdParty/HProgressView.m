//
//  HProgressView.m
//  Join
//
//  Created by 黄克瑾 on 2017/2/2.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "HProgressView.h"

@interface HProgressView ()

/**
 *  进度值0-1.0之间
 */
@property (nonatomic,assign)CGFloat progressValue;

@property (nonatomic, assign) CGFloat currentTime;

@property (nonatomic,assign) BOOL startCircle;

@end

@implementation HProgressView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (self.startCircle) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        NSLog(@"width = %f",self.frame.size.width);
        CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.width/2.0);  //设置圆心位置
        CGFloat radius = self.frame.size.width/2.0;  //设置半径
        CGFloat startA = - M_PI_2;  //圆起点位置
        CGFloat endB = -M_PI_2 + M_PI * 2 * _progressValue;  //圆终点位置

        UIBezierPath *pathBack = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endB clockwise:YES];

        CGContextSetLineWidth(context, 7); //设置线条宽度
        [[UIColor redColor] setStroke]; //设置描边颜色

        [[UIColor redColor] setFill];
        CGContextFillRect(context, CGRectMake((width - 30) / 2.0, (height - 30) / 2.0, 30, 30));

        CGContextAddPath(context, pathBack.CGPath); //把路径添加到上下文

        CGContextStrokePath(context);  //渲染
    } else {
        CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
        NSLog(@"width = %f",self.frame.size.width);
        CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.width/2.0);  //设置圆心位置
        CGFloat radius = self.frame.size.width/2.0 - 5;  //设置半径
        CGFloat startA = - M_PI_2;  //圆起点位置
        CGFloat endA = -M_PI_2 + M_PI * 2;  //圆终点位置

        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];

//        CGContextSetLineWidth(ctx, 5); //设置线条宽度
        [[UIColor clearColor] setFill]; //设置描边颜色

        CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
        CGContextStrokePath(ctx);  //渲染
    }
}

- (void)setTimeMax:(NSInteger)timeMax {
    _timeMax = timeMax;
    self.currentTime = 0;
    self.progressValue = 0;
    [self setNeedsDisplay];
    self.hidden = NO;
    [self performSelector:@selector(startProgress) withObject:nil afterDelay:0.1];
}

- (void)clearProgress {
    _currentTime = _timeMax;
    self.hidden = YES;
    self.startCircle = NO;
}

- (void)startProgress {
    _currentTime += 0.1;
    self.startCircle = YES;
    if (_timeMax > _currentTime) {
        _progressValue = _currentTime/_timeMax;
        NSLog(@"progress = %f",_progressValue);
        [self setNeedsDisplay];
        [self performSelector:@selector(startProgress) withObject:nil afterDelay:0.1];
    }
    
//    if (_timeMax <= _currentTime) {
//        [self clearProgress];
//    }
}

- (void)reDrawRect {
    self .startCircle = NO;
    [self setNeedsDisplay];
    self.backgroundColor = [UIColor lightGrayColor];
}

@end
