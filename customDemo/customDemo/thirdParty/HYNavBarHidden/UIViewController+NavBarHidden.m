//
//  UIViewController+scrollerHidden.m
//  自定义导航控制器
//
//  Created by HelloYeah on 16/3/12.
//  Copyright © 2016年 HelloYeah. All rights reserved.
//

#import "UIViewController+NavBarHidden.h"
#import <objc/runtime.h>

@interface UIViewController ()
@property (nonatomic,strong) UIImage  * navBarBackgroundImage; //导航条的背景图片
@property (nonatomic,weak) UIScrollView * keyScrollView;// 需要监听的view
@property (nonatomic,assign) HYHidenControlOptions  hy_hidenControlOptions;// 设置导航条上的标签是否需要跟随滚动变化透明度,默认不会跟随滚动变化透明度
@property (nonatomic,assign) CGFloat scrolOffsetY;// ScrollView的Y轴偏移量大于scrolOffsetY的距离后,导航条的alpha为1
@property (nonatomic,assign) CGFloat alpha;
@end

@implementation UIViewController (NavBarHidden)

#pragma mark - ************* 通过运行时动态添加存储属性 ******************
//定义关联的Key
static const char *key = "keyScrollView";
- (UIScrollView *)keyScrollView{
   
    return objc_getAssociatedObject(self, key);
}

- (void)setKeyScrollView:(UIScrollView *)keyScrollView{
    objc_setAssociatedObject(self, key, keyScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//定义关联的Key
static const char *navBarBackgroundImageKey = "navBarBackgroundImage";
- (UIImage *)navBarBackgroundImage{
    return objc_getAssociatedObject(self, navBarBackgroundImageKey);
}

- (void)setNavBarBackgroundImage:(UIImage *)navBarBackgroundImage{
    objc_setAssociatedObject(self, navBarBackgroundImageKey, navBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//定义关联的Key
static const char *scrolOffsetYKey = "offsetY";
- (CGFloat)scrolOffsetY{
    
    return [objc_getAssociatedObject(self, scrolOffsetYKey) floatValue];
}

- (void)setScrolOffsetY:(CGFloat)scrolOffsetY{
    
    objc_setAssociatedObject(self, scrolOffsetYKey, @(scrolOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//定义关联的Key
static const char  *alphaKey = "alpha";
- (CGFloat)alpha{
    
    return [objc_getAssociatedObject(self, alphaKey) floatValue];
}

- (void)setAlpha:(CGFloat)alpha{
    
    objc_setAssociatedObject(self, alphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//定义关联的Key
static const char * hy_hidenControlOptionsKey = "hy_hidenControlOptions";
- (NSInteger)hy_hidenControlOptions{
    
    return [objc_getAssociatedObject(self,hy_hidenControlOptionsKey) integerValue];
}
- (void)setHy_hidenControlOptions:(NSInteger)hy_hidenControlOptions{
    
    objc_setAssociatedObject(self, hy_hidenControlOptionsKey, @(hy_hidenControlOptions), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - **************** 核心代码-对外接口功能实现代码 ******************

- (void)setKeyScrollView:(UIScrollView *)keyScrollView scrolOffsetY:(CGFloat)scrolOffsetY options:(HYHidenControlOptions)options{
    
    self.keyScrollView = keyScrollView;
    self.hy_hidenControlOptions = options;
    self.scrolOffsetY = scrolOffsetY;
    [self.keyScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)hy_viewWillAppear:(BOOL)animated {
    
    //设置背景图片
    [self.navigationController.navigationBar setBackgroundImage:self.navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    //清除边框，设置一张空的图片
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self setNavSubViewsAlpha];
    
}

- (void)hy_viewWillDisappear:(BOOL)animated {
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

}

- (void)hy_viewDidDisappear:(BOOL)animated {
    
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
}

#pragma mark - *********************** 内部方法 **********************

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    CGFloat offsetY = self.scrolOffsetY;
    CGPoint point = self.keyScrollView.contentOffset;
    self.alpha =  point.y/offsetY;
    self.alpha = (self.alpha <= 0)?0:self.alpha;
    self.alpha = (self.alpha >= 1)?1:self.alpha;
    [self setNavSubViewsAlpha];

}


- (void)setNavSubViewsAlpha {
    
    self.navigationItem.leftBarButtonItem.customView.alpha = self.hy_hidenControlOptions & 1?self.alpha:1;
    self.navigationItem.titleView.alpha = self.hy_hidenControlOptions >> 1 & 1 ?self.alpha:1;
    self.navigationItem.rightBarButtonItem.customView.alpha = self.hy_hidenControlOptions >> 2 & 1?self.alpha:1;
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:self.alpha];
}

@end
