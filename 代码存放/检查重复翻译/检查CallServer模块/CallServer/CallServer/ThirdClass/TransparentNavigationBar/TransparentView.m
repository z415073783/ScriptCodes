//
//  TransparentView.m
//  TransparentNavigationBar
//
//  Created by Michael on 15/11/20.
//  Copyright © 2015年 com.51fanxing. All rights reserved.
//

#import "TransparentView.h"

@interface TransparentView ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat initOffsetY;
@property (nonatomic, assign) CGRect initStretchViewFrame;
@property (nonatomic, assign) CGFloat initSelfHeight;
@property (nonatomic, assign) CGFloat initContentHeight;

@end
@implementation TransparentView

+ (instancetype)dropHeaderViewWithFrame:(CGRect)frame contentView:(UIView *)contentView stretchView:(UIView *)stretchView
{
    TransparentView *dropHeaderView = [[TransparentView alloc] init];
    dropHeaderView.frame = frame;
    dropHeaderView.contentView = contentView;
    dropHeaderView.stretchView = stretchView;
    
    stretchView.contentMode = UIViewContentModeScaleAspectFill;
    stretchView.clipsToBounds = YES;
    return dropHeaderView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    if (newSuperview != nil) {
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        UIScrollView *scrollView = (UIScrollView *)newSuperview;
        
        self.initOffsetY = scrollView.contentOffset.y;
        self.initStretchViewFrame = self.stretchView.frame;
        self.initSelfHeight = self.frame.size.height;
        self.initContentHeight = self.contentView.frame.size.height;
    }
    
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    [self addSubview:contentView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat offsetY = [change[@"new"] CGPointValue].y - self.initOffsetY;

    if (offsetY > 0) {
        self.stretchView.frame = CGRectMake(self.stretchView.frame.origin.x, self.initStretchViewFrame.origin.y + offsetY,self.stretchView.frame.size.width , self.initStretchViewFrame.size.height - offsetY);
    }else{
        self.stretchView.frame = CGRectMake(self.stretchView.frame.origin.x, self.initStretchViewFrame.origin.y + offsetY,self.stretchView.frame.size.width , self.initStretchViewFrame.size.height - offsetY);
    }
}


@end
