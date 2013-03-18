//
//  UINavigationViewController.m
//  163NewsEffect
//
//  Created by zhuge.zzy on 13-2-1.
//  Copyright (c) 2013年 zhuge.zzy. All rights reserved.
//

#import "UINavigationViewController.h"
#import "UINavigationView.h"

@interface UINavigationViewController ()

@end

@implementation UINavigationViewController

@synthesize rootView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    rootView = [[UINavigationView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    rootView.backgroundColor = [UIColor whiteColor];
    rootView.delegate = self;
    //[rootView setBSupportSlidingTurnPage:NO];
    [self.view addSubview:rootView];
    [self setCurrentView:rootView];
    [rootView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubView:(UIView *)subView
{
    CGRect rcSubView = subView.frame;
    rcSubView.origin.x = [[UIScreen mainScreen] bounds].size.width;
    rcSubView.origin.y = 0;
    [subView setFrame:rcSubView];
    
    [self.view addSubview:subView];
}

- (IBAction)pushView:(id)sender
{
    [m_currentView pushView];
}

- (IBAction)popView:(id)sender
{
    [m_currentView popView];
}

- (void) setCurrentView:(UIView *)currentView
{
    m_currentView = (UINavigationView *)currentView;
}

- (void)dealloc
{    
    [super dealloc];
}

@end
