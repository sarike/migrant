//
//  AppDelegate.m
//  migrant_ios
//
//  Created by comger on 13-7-16.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "AppDelegate.h"
#import "MyViewController.h"
#import "AccountListController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    
    [self.window makeKeyAndVisible];
    //self.tabBarController.tabBar.selectedItem = nil;
    return YES;
}
							


@end
