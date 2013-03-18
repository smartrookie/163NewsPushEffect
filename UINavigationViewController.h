//
//  UINavigationViewController.h
//  163NewsEffect
//
//  Created by zhuge.zzy on 13-2-1.
//  Copyright (c) 2013年 zhuge.zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UINavigationView;
@protocol UINavigationViewDelegate;

@interface UINavigationViewController : UIViewController<UINavigationViewDelegate>
{
    UINavigationView *m_currentView;
}

@property (nonatomic, assign) UINavigationView *rootView;

- (void)addSubView:(UIView *)subView;

- (IBAction)pushView:(id)sender;
- (IBAction)popView:(id)sender;

@end
