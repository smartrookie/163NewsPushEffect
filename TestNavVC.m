//
//  TestNavVC.m
//  163NewsEffect
//
//  Created by zhuge.zzy on 13-2-1.
//  Copyright (c) 2013年 zhuge.zzy. All rights reserved.
//

#import "TestNavVC.h"
#import "UINavigationView.h"

@interface TestNavVC ()

@end

@implementation TestNavVC

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
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pushButton setFrame:CGRectMake(130, 218, 61, 44)];
    [pushButton setTitle:@"Push" forState:UIControlStateNormal];
    [pushButton setBackgroundColor:[UIColor clearColor]];
    [pushButton addTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];
    
    UINavigationView *firstView = [[UINavigationView alloc] initWithFrame:self.view.frame];
    firstView.backgroundColor = [UIColor greenColor];
    firstView.delegate = self;
    UIButton *pushButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pushButton2 setFrame:CGRectMake(130, 218, 61, 44)];
    [pushButton2 setTitle:@"Push" forState:UIControlStateNormal];
    [pushButton2 setBackgroundColor:[UIColor clearColor]];
    [pushButton2 addTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *popButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [popButton2 setFrame:CGRectMake(20, 20, 61, 44)];
    [popButton2 setTitle:@"Pop" forState:UIControlStateNormal];
    [popButton2 setBackgroundColor:[UIColor clearColor]];
    [popButton2 addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    [firstView addSubview:popButton2];
    [firstView addSubview:pushButton2];
    
    UINavigationView *secondView = [[UINavigationView alloc] initWithFrame:self.view.frame];
    secondView.backgroundColor = [UIColor redColor];
    secondView.delegate = self;
    UIButton *popButton3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [popButton3 setFrame:CGRectMake(20, 20, 61, 44)];
    [popButton3 setTitle:@"Pop" forState:UIControlStateNormal];
    [popButton3 setBackgroundColor:[UIColor clearColor]];
    [popButton3 addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:popButton3];
    
    [self.rootView setNextUIView:firstView];
    
    [firstView setPreUIView:self.rootView];
    [firstView setNextUIView:secondView];
    
    [secondView setPreUIView:firstView];
    
    [self addSubView:firstView];
    [self addSubView:secondView];
    [firstView release];
    [secondView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
