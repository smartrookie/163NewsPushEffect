//
//  UINavigationView.m
//  163NewsEffect
//
//  Created by zhuge.zzy on 13-2-1.
//  Copyright (c) 2013年 zhuge.zzy. All rights reserved.
//

#import "UINavigationView.h"
#import <QuartzCore/QuartzCore.h>

#define kNeedRestoreWidth 120
#define kNeedAdjustDx 6
#define kNeedAdjustAlpha 0.7

@implementation UINavigationView

@synthesize preUIView;
@synthesize nextUIView;
@synthesize bSupportSlidingTurnPage = m_bSupportSlidingTurnPage;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    m_bNeedRestoreThisViewLayout = YES;
    m_fDXCount = 0;
    m_bNeedPushNextView = NO;
    m_bSupportSlidingTurnPage = YES;
    preUIView = nil;
    nextUIView = nil;
    
    m_bAlreadySlidingDirection = NO;
    m_bLeftSliding = NO;
    m_bRightSliding = NO;
    
    m_shadowView = nil;
    
//    self.layer.masksToBounds = NO;
//    self.layer.shadowOffset = CGSizeMake(-3, -3);
//    self.layer.shadowRadius = 1;
//    self.layer.shadowOpacity = 0.6;
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    m_ptStartLocation = [[touches anyObject] locationInView:self];
}

- (void)resetViewFrameAndAlpha:(UIView *)subView
{
    while (subView != nil) {
        CGRect rcView = subView.frame;
        rcView.origin.x = 0;
        rcView.origin.y = 0;
        rcView.size.width = [[UIScreen mainScreen] bounds].size.width;
        rcView.size.height = [[UIScreen mainScreen] bounds].size.height - 20;
        
        [UIView animateWithDuration:0.1 animations:^{
            [subView setFrame:rcView];
        }];
        
        subView = [(UINavigationView *)subView preUIView];
    }
}

- (void)changeViewFrameAndAlpha:(UIView *)currentSubView
{
    float proportion = [[UIScreen mainScreen] bounds].size.width - currentSubView.frame.origin.x;
    float ratio = proportion / ([[UIScreen mainScreen] bounds].size.width);
    float alpha = kNeedAdjustAlpha * ratio;
    if(m_shadowView != nil){
        m_shadowView.alpha = alpha;
    }
    
    UIView *subView = [(UINavigationView *)currentSubView preUIView];
    while (subView != nil) {
        CGRect rcView = subView.frame;
        rcView.origin.x = kNeedAdjustDx * ratio;
        rcView.origin.y = kNeedAdjustDx * ratio;
        rcView.size.width = [[UIScreen mainScreen] bounds].size.width - kNeedAdjustDx * ratio * 2;
        rcView.size.height = [[UIScreen mainScreen] bounds].size.height - 20 - kNeedAdjustDx * ratio * 2;
        
        [subView setFrame:rcView];
        subView = [(UINavigationView *)subView preUIView];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!m_bSupportSlidingTurnPage){
        return;
    }

    CGPoint endLocation = [[touches anyObject] locationInView:self];
    float dx = endLocation.x - m_ptStartLocation.x;
    m_fDXCount += dx;
    
    if(!m_bAlreadySlidingDirection){
        //m_bAlreadySlidingDirection = YES;
        if(m_fDXCount >= 0){
            m_bRightSliding = YES;
        }
        else{
            m_bLeftSliding = YES;
        }
        
        m_shadowView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        m_shadowView.backgroundColor = [UIColor blackColor];
    }

    if(m_bRightSliding && m_fDXCount > 0 && preUIView != nil){ //pop
        if(m_fDXCount < kNeedRestoreWidth){ //not pop
            m_bNeedRestoreThisViewLayout = YES;
        }
        else{ //pop
            m_bNeedRestoreThisViewLayout = NO;
        }
        
        // 不断改变上一层view的大小并增加一个阴影层
        if(!m_bAlreadySlidingDirection){
            m_bAlreadySlidingDirection = YES;
            if(preUIView != nil){
                [preUIView addSubview:m_shadowView];
            }
        }
        [self changeViewFrameAndAlpha:self];
        
        CGRect rcView = self.frame;
        rcView.origin.x += dx;
        rcView.origin.x = rcView.origin.x >= [[UIScreen mainScreen] bounds].size.width ? [[UIScreen mainScreen] bounds].size.width : rcView.origin.x;
        [self setFrame:rcView];
    }
    else if(m_bLeftSliding && dx < 0 && nextUIView != nil){ //push
        if(dx > kNeedRestoreWidth * -1){ //not push
            m_bNeedPushNextView = NO;
        }
        else{ //push
            m_bNeedPushNextView = YES;
        }
        
        CGRect rcView = nextUIView.frame;
        rcView.origin.x = [[UIScreen mainScreen] bounds].size.width + dx;
        rcView.origin.x = rcView.origin.x <= 0 ? 0 : rcView.origin.x;
        [nextUIView setFrame:rcView];
        
        // 不断改变本层view的大小并增加一个阴影层
        if(!m_bAlreadySlidingDirection){
            m_bAlreadySlidingDirection = YES;
            [self addSubview:m_shadowView];
        }
        [self changeViewFrameAndAlpha:nextUIView];
    }   
}

- (void)popOrPushView:(UIView *)subView xOrigin:(NSInteger)xPos
{
    if(subView != nil){
        if(subView == self){
            if(xPos == 0){
                [delegate setCurrentView:self];
            }
            else{
                [delegate setCurrentView:preUIView];
            }
        }else if(subView == nextUIView){
            if(xPos == 0){
                [delegate setCurrentView:nextUIView];
            }
            else{
                [delegate setCurrentView:self];
            }
        }
        
        CGRect rcView = subView.frame;
        rcView.origin.x = xPos;
        [UIView animateWithDuration:0.5 animations:^{
            [subView setFrame:rcView];
            
        } completion:^(BOOL finished) {
            m_bAlreadySlidingDirection = NO;
            m_bRightSliding = NO;
            m_bLeftSliding = NO;
            [self resetViewFrameAndAlpha:[(UINavigationView *)subView preUIView]];
            [m_shadowView removeFromSuperview];
        }];
    }
}

- (void)restoreViewRect
{
    if(m_bRightSliding){
        if(m_bNeedRestoreThisViewLayout){
            [self popOrPushView:self xOrigin:0];
        }
        else{
            // pop this view
            [self popOrPushView:self xOrigin:[[UIScreen mainScreen] bounds].size.width];
        }
        m_bNeedRestoreThisViewLayout = YES;
    }
    else if(m_bLeftSliding && nextUIView != nil){
        if(!m_bNeedPushNextView){
            // push the next view
            [self popOrPushView:nextUIView xOrigin:[[UIScreen mainScreen] bounds].size.width];
        }
        else{
            [self popOrPushView:nextUIView xOrigin:0];
        }
        m_bNeedPushNextView = NO;
    }
    
    m_fDXCount = 0;    
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!m_bSupportSlidingTurnPage){
        return;
    }
    [self restoreViewRect];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!m_bSupportSlidingTurnPage){
        return;
    }
    [self restoreViewRect];
}

- (void)popViewTimerSel
{
    CGRect rcView = self.frame;
    rcView.origin.x += 5;
    if(rcView.origin.x == [[UIScreen mainScreen] bounds].size.width){
        [m_popOrPushViewTimer invalidate];
        [self popOrPushView:self xOrigin:[[UIScreen mainScreen] bounds].size.width];
    }
    [self setFrame:rcView];
    [self changeViewFrameAndAlpha:self];
}

- (void)popView
{
    // 不断改变self位置 从0到[[UIScreen mainScreen] bounds].size.width
    m_popOrPushViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.006 target:self selector:@selector(popViewTimerSel) userInfo:nil repeats:YES];
    m_shadowView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    m_shadowView.backgroundColor = [UIColor blackColor];
    if(preUIView != nil){
        [preUIView addSubview:m_shadowView];
    }
}

- (void)pushViewTimerSel
{
    CGRect rcView = nextUIView.frame;
    rcView.origin.x -= 5;
    if(rcView.origin.x == 0){
        [m_popOrPushViewTimer invalidate];
        [self popOrPushView:nextUIView xOrigin:0];
    }
    [nextUIView setFrame:rcView];
    [self changeViewFrameAndAlpha:nextUIView];
}

- (void)pushView
{
    // 不断改变nextUIView位置 从[[UIScreen mainScreen] bounds].size.width到0
    m_popOrPushViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.006 target:self selector:@selector(pushViewTimerSel) userInfo:nil repeats:YES];
    m_shadowView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    m_shadowView.backgroundColor = [UIColor blackColor];
    [self addSubview:m_shadowView];
}

- (void)dealloc
{    
    [super dealloc];
}

@end
