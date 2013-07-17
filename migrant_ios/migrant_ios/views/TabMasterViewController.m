//
//  TabMasterViewController.m
//  migrant_ios
//
//  Created by comger on 13-7-17.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "TabMasterViewController.h"
#import "HomeViewController.h"
#import "MyViewController.h"

@interface TabMasterViewController ()

@end
@implementation TabMasterViewController
@synthesize tabBar;
@synthesize homeview;
@synthesize myview;

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
    
    tabBar =[[UITabBarController alloc] init];
    tabBar.delegate = self;
    homeview = [[HomeViewController alloc] init];
    myview = [[MyViewController alloc] init];
    
    NSArray *viewControllerArray = [NSArray arrayWithObjects:homeview,myview,nil];
    tabBar.viewControllers = viewControllerArray;
    
    tabBar.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:tabBar.view];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
