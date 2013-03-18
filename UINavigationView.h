//
//  UINavigationView.h
//  163NewsEffect
//
//  Created by zhuge.zzy on 13-2-1.
//  Copyright (c) 2013年 zhuge.zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UINavigationViewDelegate <NSObject>

@required
- (void) setCurrentView:(UIView *)currentView;

@end

@interface UINavigationView : UIView
{
    CGPoint m_ptStartLocation;
    float   m_fDXCount;
    BOOL    m_bNeedRestoreThisViewLayout;
    BOOL    m_bNeedPushNextView;
    BOOL    m_bSupportSlidingTurnPage;
    
    BOOL    m_bAlreadySlidingDirection;
    BOOL    m_bLeftSliding;
    BOOL    m_bRightSliding;
    
    NSTimer *m_popOrPushViewTimer;
    UIView  *m_shadowView;
}

@property (nonatomic, assign) UIView *preUIView;
@property (nonatomic, assign) UIView *nextUIView;
@property (nonatomic, assign) BOOL bSupportSlidingTurnPage;
@property (nonatomic, assign) id<UINavigationViewDelegate>delegate;

- (void)popView;
- (void)pushView;

@end
