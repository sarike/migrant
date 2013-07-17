//
//  AppDelegate.m
//  migrant_ios
//
//  Created by comger on 13-7-16.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "AppDelegate.h"
#import "TabMasterViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    TabMasterViewController *rootview = [[TabMasterViewController alloc] init ];
    
    [self.window addSubview:rootview.view];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
							


@end
